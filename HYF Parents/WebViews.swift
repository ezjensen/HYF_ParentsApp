//
//  WebViews.swift
//  HYF Parents
//
//  Created by Eric Jensen on 7/18/25.
//

import SwiftUI
import WebKit

struct StandardWebView: UIViewRepresentable {
	let url: URL
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.navigationDelegate = context.coordinator
		webView.load(URLRequest(url: url))
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: StandardWebView
		
		init(_ parent: StandardWebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			decisionHandler(.allow)
		}
	}
}

// A simple web view that allows navigation within the webview
struct WebView: UIViewRepresentable {
	let url: URL
	
	func makeUIView(context: Context) -> WKWebView {
		let configuration = WKWebViewConfiguration()
		let preferences = WKWebpagePreferences()
		preferences.allowsContentJavaScript = true
		configuration.defaultWebpagePreferences = preferences
		
		let webView = WKWebView(frame: .zero, configuration: configuration)
		webView.navigationDelegate = context.coordinator
		webView.allowsBackForwardNavigationGestures = true
		
		// Create the URL request
		var request = URLRequest(url: url)
		request.cachePolicy = .reloadIgnoringLocalCacheData
		
		webView.load(request)
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		// Check if the current URL is different from the one we want to load
		if let currentURL = uiView.url, currentURL != url {
			var request = URLRequest(url: url)
			request.cachePolicy = .reloadIgnoringLocalCacheData
			uiView.load(request)
		} else if uiView.url == nil {
			// Initial load if no URL is currently loaded
			var request = URLRequest(url: url)
			request.cachePolicy = .reloadIgnoringLocalCacheData
			uiView.load(request)
		}
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		var parent: WebView
		
		init(_ parent: WebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
			// Check if the navigation is a link tap (not the initial page load)
			if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
				// Open in default browser
				UIApplication.shared.open(url)
				decisionHandler(.cancel) // Don't load in the WebView
				return
			}
			
			// Allow other navigation types (like initial page load)
			decisionHandler(.allow)
		}
	}
}

struct EnhancedWebView: UIViewRepresentable {
	let url: URL
	let divToShow: String
	
	func makeUIView(context: Context) -> WKWebView {
		let configuration = WKWebViewConfiguration()
		let preferences = WKWebpagePreferences()
		preferences.allowsContentJavaScript = true
		configuration.defaultWebpagePreferences = preferences
		
		// Add message handlers
		let contentController = WKUserContentController()
		contentController.add(context.coordinator, name: "imageHandler")
		contentController.add(context.coordinator, name: "fieldsHandler") // Add fields handler
		configuration.userContentController = contentController
		
		let webView = WKWebView(frame: .zero, configuration: configuration)
		webView.navigationDelegate = context.coordinator
		webView.load(URLRequest(url: url))
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		// No updates needed since content is handled in didFinish navigation
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
		var parent: EnhancedWebView
		
		init(_ parent: EnhancedWebView) {
			self.parent = parent
			super.init()
		}
		
		/// Handle messages from JavaScript
		func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
			if message.name == "imageHandler" {
				if let webView = message.webView {
					// Convert the Bandito image to a Data URL
					if let banditoImage = UIImage(named: "HYF_Bandito") {
						if let imageData = banditoImage.pngData() {
							let base64String = imageData.base64EncodedString()
							let dataURL = "data:image/png;base64,\(base64String)"
							
							// Send the image data URL back to JavaScript
							let script = "receiveBanditoImage('\(dataURL)');"
							webView.evaluateJavaScript(script)
						}
					}
				}
			} else if message.name == "fieldsHandler" {
				if let webView = message.webView {
					// Call the function from getFieldLocations.swift
					sendFieldsDataToWebView(webView)
				}
			}
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			// Check URL to determine which JavaScript to apply
			if parent.url.absoluteString.contains("maps.php") {
				applyFieldsJavaScript(webView)
			} else if parent.url.absoluteString.contains("TabbedGameSchedulesNEW.php") {
				applyScheduleJavaScript(webView)
			} else {
				applyHuntleyFilterJavaScript(webView)
			}
		}
		
		private func applyFieldsJavaScript(_ webView: WKWebView) {
			let javascript = """
			// Global variables
			var banditoImageURL = '';
			var fieldsData = [];
			
			// Function to receive the image from Swift
			function receiveBanditoImage(dataURL) {
				banditoImageURL = dataURL;
				checkDataAndRender();
			}
			
			// Function to receive fields data from Swift
			function receiveFieldsData(fieldsJSON) {
				try {
					fieldsData = JSON.parse(fieldsJSON);
					console.log("Received fields data, length:", fieldsData.length);
					checkDataAndRender();
				} catch (e) {
					console.error("Error processing fields data:", e);
				}
			}
			
			// Check if we have all data needed to render
			function checkDataAndRender() {
				console.log("Checking data, fields length:", fieldsData.length);
				if (fieldsData.length > 0) {
					renderFieldsList();
				}
			}
			
			function renderFieldsList() {
				// Create styled container
				document.body.innerHTML = '';
				document.body.style.margin = '0';
				document.body.style.padding = '0';
				
				var container = document.createElement('div');
				container.style.padding = '20px';
				container.style.backgroundColor = '#121212';
				container.style.minHeight = '100vh';
				
				// Add header
				var header = document.createElement('h1');
				header.textContent = 'Field Locations';
				header.style.color = 'white';
				header.style.textAlign = 'center';
				header.style.marginBottom = '20px';
				header.style.fontSize = '36px';
				header.style.fontWeight = 'bold';
				container.appendChild(header);
				
				// Add search input
				var searchContainer = document.createElement('div');
				searchContainer.style.marginBottom = '20px';
				searchContainer.style.position = 'sticky';
				searchContainer.style.top = '0';
				searchContainer.style.zIndex = '10';
				searchContainer.style.backgroundColor = '#121212';
				searchContainer.style.padding = '10px 0';
				
				var searchInput = document.createElement('input');
				searchInput.type = 'text';
				searchInput.placeholder = 'Search fields...';
				searchInput.style.width = '100%';
				searchInput.style.padding = '15px';
				searchInput.style.fontSize = '20px';
				searchInput.style.borderRadius = '10px';
				searchInput.style.border = '1px solid #444';
				searchInput.style.backgroundColor = '#1e1e1e';
				searchInput.style.color = 'white';
				searchContainer.appendChild(searchInput);
				container.appendChild(searchContainer);
				
				// Create a card for each field
				var fieldsList = document.createElement('div');
				fieldsList.id = 'fields-list';
				
				// Sort fields by name
				fieldsData.sort((a, b) => a.name.localeCompare(b.name));
				
				// Home fields first
				let homeFields = fieldsData.filter(f => f.is_home_field);
				let awayFields = fieldsData.filter(f => !f.is_home_field);
				let sortedFields = [...homeFields, ...awayFields];
				
				sortedFields.forEach(function(field) {
					var fieldCard = document.createElement('div');
					fieldCard.className = 'field-card';
					fieldCard.setAttribute('data-name', field.name.toLowerCase());
					fieldCard.setAttribute('data-address', field.address.toLowerCase());
					fieldCard.style.backgroundColor = field.is_home_field ? '#3c1212' : '#1e1e1e';
					fieldCard.style.padding = '22px';
					fieldCard.style.marginBottom = '18px';
					fieldCard.style.borderRadius = '12px';
					fieldCard.style.cursor = 'pointer';
					fieldCard.style.position = 'relative';
					fieldCard.style.boxShadow = '0 2px 8px rgba(0,0,0,0.2)';
					
					// Add Bandito image for home fields
					if (field.is_home_field) {
						var banditoIcon = document.createElement('img');
						banditoIcon.src = banditoImageURL;
						banditoIcon.style.width = '70px';
						banditoIcon.style.height = '70px';
						banditoIcon.style.position = 'absolute';
						banditoIcon.style.right = '20px';
						banditoIcon.style.top = '22px';
						fieldCard.appendChild(banditoIcon);
						
						// Add a "HOME" label
						var homeLabel = document.createElement('div');
						homeLabel.textContent = 'HOME';
						homeLabel.style.position = 'absolute';
						homeLabel.style.top = '15px';
						homeLabel.style.right = '20px';
						homeLabel.style.backgroundColor = '#e63946';
						homeLabel.style.color = 'white';
						homeLabel.style.padding = '5px 10px';
						homeLabel.style.borderRadius = '5px';
						homeLabel.style.fontSize = '14px';
						homeLabel.style.fontWeight = 'bold';
						homeLabel.style.letterSpacing = '1px';
						fieldCard.appendChild(homeLabel);
					}
					
					// Field name (tappable)
					var fieldName = document.createElement('h2');
					fieldName.textContent = field.name;
					fieldName.style.color = 'white';
					fieldName.style.marginBottom = '12px';
					fieldName.style.fontSize = '32px';
					fieldName.style.fontWeight = 'bold';
					// Adjust padding for home fields to make room for icon
					if (field.is_home_field) {
						fieldName.style.paddingRight = '80px';
					}
					fieldCard.appendChild(fieldName);
					
					// Field address
					var fieldAddress = document.createElement('p');
					fieldAddress.textContent = field.address;
					fieldAddress.style.color = '#dddddd';
					fieldAddress.style.fontSize = '22px';
					fieldAddress.style.lineHeight = '1.4';
					fieldCard.appendChild(fieldAddress);
					
					// Add notes if available
					if (field.notes) {
						var notesLabel = document.createElement('div');
						notesLabel.textContent = 'Notes:';
						notesLabel.style.color = '#aaa';
						notesLabel.style.marginTop = '12px';
						notesLabel.style.fontSize = '18px';
						notesLabel.style.fontWeight = 'bold';
						fieldCard.appendChild(notesLabel);
						
						var fieldNotes = document.createElement('p');
						fieldNotes.textContent = field.notes;
						fieldNotes.style.color = '#bbbbbb';
						fieldNotes.style.fontSize = '20px';
						fieldNotes.style.lineHeight = '1.4';
						fieldNotes.style.marginTop = '6px';
						fieldCard.appendChild(fieldNotes);
					}
					
					// Make the entire card tappable to open Google Maps
					fieldCard.onclick = function() {
						window.location.href = 'https://www.google.com/maps/search/?api=1&query=' + encodeURIComponent(field.address);
					};
					
					fieldsList.appendChild(fieldCard);
				});
				
				container.appendChild(fieldsList);
				
				// Add global styles
				var style = document.createElement('style');
				style.textContent = `
					body {
						background-color: #121212;
						color: #ffffff;
						font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
						padding: 0;
						margin: 0;
						line-height: 1.5;
						font-size: 24px;
					}
					
					@media (max-width: 375px) {
						h1 { font-size: 32px; }
						h2 { font-size: 28px; }
						p { font-size: 20px; }
						input { font-size: 18px; padding: 12px; }
					}
				`;
				document.head.appendChild(style);
				
				// Replace page content with our list
				document.body.appendChild(container);
				
				// Add search functionality
				searchInput.addEventListener('input', function() {
					const searchText = this.value.toLowerCase();
					const cards = document.querySelectorAll('.field-card');
					
					cards.forEach(card => {
						const name = card.getAttribute('data-name');
						const address = card.getAttribute('data-address');
						
						if (name.includes(searchText) || address.includes(searchText)) {
							card.style.display = 'block';
						} else {
							card.style.display = 'none';
						}
					});
				});
			}
			
			// Request data from Swift
			window.webkit.messageHandlers.imageHandler.postMessage('getBanditoImage');
			window.webkit.messageHandlers.fieldsHandler.postMessage('getFields');
			"""
			
			webView.evaluateJavaScript(javascript) { result, error in
				if let error = error {
					print("JavaScript error: \(error)")
				} else {
					print("Fields JavaScript executed successfully")
				}
			}
		}
		
		private func applyScheduleJavaScript(_ webView: WKWebView) {
			let javascript = """
			// Apply dark mode to schedule page
			document.body.style.backgroundColor = '#121212';
			document.body.style.color = '#FFFFFF';
			
			// Function to find and process tables for Huntley games
			function findAndFilterHuntleyGames() {
				// Find the relevant div to show
				var targetDiv = document.getElementById('\(parent.divToShow)');
				if (targetDiv) {
					// Process all tables in the target div
					var tables = targetDiv.querySelectorAll('table');
					tables.forEach(function(table) {
						// First, identify which columns are Home and Away
						let homeColIndex = -1;
						let awayColIndex = -1;
						
						// Check header row for column names
						let headerRow = table.querySelector('tr');
						if (headerRow) {
							let headerCells = headerRow.querySelectorAll('th');
							for (let i = 0; i < headerCells.length; i++) {
								let cellText = headerCells[i].textContent.trim().toLowerCase();
								if (cellText === 'home' || cellText === 'home team') {
									homeColIndex = i;
								} else if (cellText === 'away' || cellText === 'away team' || cellText === 'visitor') {
									awayColIndex = i;
								}
							}
							
							// If header cells don't have th tags, try td tags
							if (homeColIndex < 0 && awayColIndex < 0) {
								headerCells = headerRow.querySelectorAll('td');
								for (let i = 0; i < headerCells.length; i++) {
									let cellText = headerCells[i].textContent.trim().toLowerCase();
									if (cellText === 'home' || cellText === 'home team') {
										homeColIndex = i;
									} else if (cellText === 'away' || cellText === 'away team' || cellText === 'visitor') {
										awayColIndex = i;
									}
								}
							}
						}
						
						// If we still couldn't identify columns, use reasonable defaults
						if (homeColIndex < 0 && awayColIndex < 0) {
							// Try to find Huntley in any cell to determine which columns might be team columns
							let rows = table.querySelectorAll('tr');
							let huntleyColumns = [];
							
							rows.forEach(function(row) {
								let cells = row.querySelectorAll('td');
								for (let i = 0; i < cells.length; i++) {
									if (cells[i].textContent.includes('Huntley')) {
										huntleyColumns.push(i);
									}
								}
							});
							
							// Count frequencies of columns where Huntley appears
							if (huntleyColumns.length > 0) {
								let columnCounts = {};
								huntleyColumns.forEach(col => {
									columnCounts[col] = (columnCounts[col] || 0) + 1;
								});
								
								// Get the two most frequent columns
								let sortedColumns = Object.keys(columnCounts).sort((a, b) => columnCounts[b] - columnCounts[a]);
								if (sortedColumns.length >= 2) {
									homeColIndex = parseInt(sortedColumns[0]);
									awayColIndex = parseInt(sortedColumns[1]);
								} else if (sortedColumns.length === 1) {
									// If only one column has Huntley, try to guess the other one
									homeColIndex = parseInt(sortedColumns[0]);
									// Assume the away column is adjacent
									awayColIndex = homeColIndex === 0 ? 1 : homeColIndex - 1;
								}
							} else {
								// Last resort - use columns 2 and 3 which are common for team columns
								homeColIndex = 2;
								awayColIndex = 3;
							}
						}
						
						// Now process all rows to filter for Huntley
						let rows = table.querySelectorAll('tr');
						for (let i = 0; i < rows.length; i++) {
							let row = rows[i];
							let cells = row.querySelectorAll('td');
							
							// Skip rows with no data cells or header rows
							if (cells.length === 0 || row.querySelector('th')) {
								row.style.display = ''; // Always show header rows
								continue;
							}
							
							let huntleyFound = false;
							
							// Check if Huntley is in either home or away column
							if (homeColIndex >= 0 && homeColIndex < cells.length) {
								if (cells[homeColIndex].textContent.includes('Huntley')) {
									huntleyFound = true;
									cells[homeColIndex].innerHTML = cells[homeColIndex].innerHTML.replace(
										/(Huntley)/gi,
										'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
									);
								}
							}
							
							if (awayColIndex >= 0 && awayColIndex < cells.length) {
								if (cells[awayColIndex].textContent.includes('Huntley')) {
									huntleyFound = true;
									cells[awayColIndex].innerHTML = cells[awayColIndex].innerHTML.replace(
										/(Huntley)/gi,
										'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
									);
								}
							}
							
							// Hide rows that don't contain Huntley in team columns
							if (!huntleyFound) {
								row.style.display = 'none';
							} else {
								// Highlight Huntley rows
								row.style.backgroundColor = '#3c0000'; // Dark red background
								row.style.color = 'white';
								row.style.fontWeight = 'bold';
							}
						}
					});
					
					// Hide all content divs first
					var contentDivs = document.querySelectorAll('div[id^="box"]');
					contentDivs.forEach(function(div) {
						div.style.display = 'none';
					});
					
					// Show only our target div
					targetDiv.style.display = 'block';
					targetDiv.style.backgroundColor = '#121212';
					targetDiv.style.color = '#FFFFFF';
					targetDiv.style.padding = '15px';
					
					// Style tables for better readability
					var tables = targetDiv.querySelectorAll('table');
					tables.forEach(function(table) {
						table.style.backgroundColor = '#1E1E1E';
						table.style.color = '#FFFFFF';
						table.style.borderCollapse = 'collapse';
						table.style.width = '100%';
						table.style.marginBottom = '20px';
						
						var cells = table.querySelectorAll('td, th');
						cells.forEach(function(cell) {
							cell.style.border = '1px solid #333';
							cell.style.padding = '12px';
							cell.style.fontSize = '16px';
						});
						
						// Style header cells
						var headerCells = table.querySelectorAll('th');
						headerCells.forEach(function(cell) {
							cell.style.backgroundColor = '#333';
							cell.style.color = '#FFF';
							cell.style.textAlign = 'center';
							cell.style.fontWeight = 'bold';
							cell.style.fontSize = '18px';
						});
					});
					
					// Style links
					var links = targetDiv.querySelectorAll('a');
					links.forEach(function(link) {
						link.style.color = '#ff6b6b';
					});
				}
			}
			
			// Hide unnecessary elements
			var headerElements = document.querySelectorAll('header, nav, #header, .header');
			headerElements.forEach(function(el) {
				el.style.display = 'none';
			});
			
			var footerElements = document.querySelectorAll('footer, #footer, .footer');
			footerElements.forEach(function(el) {
				el.style.display = 'none';
			});
			
			// Hide ads
			var adElements = document.querySelectorAll('[id*="ad"], [class*="ad"], [id*="banner"], [class*="banner"]');
			adElements.forEach(function(el) {
				el.style.display = 'none';
			});
			
			// Remove background images
			var elementsWithBg = document.querySelectorAll('[style*="background-image"]');
			elementsWithBg.forEach(function(el) {
				el.style.backgroundImage = 'none';
				el.style.backgroundColor = '#121212';
			});
			
			// Run the filter function
			findAndFilterHuntleyGames();
			
			// Run again after a delay to catch dynamically loaded content
			setTimeout(findAndFilterHuntleyGames, 1000);
			"""
			
			webView.evaluateJavaScript(javascript) { result, error in
				if let error = error {
					print("Schedule JavaScript error: \(error)")
				} else {
					print("Schedule JavaScript executed successfully")
				}
			}
		}
		
		private func applyHuntleyFilterJavaScript(_ webView: WKWebView) {
			let javascript = """
			// Apply dark mode to the page
			document.body.style.backgroundColor = '#121212';
			document.body.style.color = '#FFFFFF';
			
			// Function to filter schedule tables for Huntley games
			function filterSchedulesForHuntley() {
				// Process all tables
				const tables = document.querySelectorAll('table');
				tables.forEach(function(table) {
					// First pass: identify home and away columns
					let homeColIndex = -1;
					let awayColIndex = -1;
					
					// Find headers to identify columns
					const rows = table.querySelectorAll('tr');
					if (rows.length > 0) {
						// First try to find header cells
						const headerCells = rows[0].querySelectorAll('th');
						for (let j = 0; j < headerCells.length; j++) {
							const text = headerCells[j].textContent.trim().toLowerCase();
							if (text === 'home' || text === 'home team') {
								homeColIndex = j;
							} else if (text === 'away' || text === 'away team' || text === 'visitor') {
								awayColIndex = j;
							}
						}
						
						// If no th elements, check first row td elements
						if (homeColIndex < 0 && awayColIndex < 0) {
							const firstRowCells = rows[0].querySelectorAll('td');
							for (let j = 0; j < firstRowCells.length; j++) {
								const text = firstRowCells[j].textContent.trim().toLowerCase();
								if (text === 'home' || text === 'home team') {
									homeColIndex = j;
								} else if (text === 'away' || text === 'away team' || text === 'visitor') {
									awayColIndex = j;
								}
							}
						}
					}
					
					// If we still don't have the columns, try to find them by looking for Huntley
					if (homeColIndex < 0 && awayColIndex < 0) {
						// Find columns that contain "Huntley"
						const huntleyColumns = [];
						rows.forEach(function(row) {
							const cells = row.querySelectorAll('td');
							for (let j = 0; j < cells.length; j++) {
								if (cells[j].textContent.includes('Huntley')) {
									huntleyColumns.push(j);
								}
							}
						});
						
						// Use the most common columns where Huntley appears
						if (huntleyColumns.length > 0) {
							const columnCounts = {};
							huntleyColumns.forEach(col => {
								columnCounts[col] = (columnCounts[col] || 0) + 1;
							});
							
							// Get the two most frequent columns
							const sortedColumns = Object.keys(columnCounts).sort((a, b) => 
								columnCounts[b] - columnCounts[a]
							);
							
							if (sortedColumns.length >= 2) {
								homeColIndex = parseInt(sortedColumns[0]);
								awayColIndex = parseInt(sortedColumns[1]);
							} else if (sortedColumns.length === 1) {
								// If only one column has Huntley
								homeColIndex = parseInt(sortedColumns[0]);
								// Guess the other column is adjacent
								awayColIndex = homeColIndex + 1;
								if (awayColIndex >= rows[0].querySelectorAll('td').length) {
									awayColIndex = homeColIndex - 1;
								}
							}
						} else {
							// Default to columns that are commonly used for team names
							// in many sport schedules (usually columns 2-4)
							homeColIndex = 2;
							awayColIndex = 3;
						}
					}
					
					console.log('Found Home column at index:', homeColIndex);
					console.log('Found Away column at index:', awayColIndex);
					
					// Now process all rows to filter for Huntley
					for (let i = 0; i < rows.length; i++) {
						const row = rows[i];
						
						// Always display header rows
						if (row.querySelector('th')) {
							row.style.display = '';
							continue;
						}
						
						const cells = row.querySelectorAll('td');
						if (cells.length === 0) continue;
						
						let huntleyFound = false;
						
						// Check home team column
						if (homeColIndex >= 0 && homeColIndex < cells.length) {
							if (cells[homeColIndex].textContent.includes('Huntley')) {
								huntleyFound = true;
								cells[homeColIndex].innerHTML = cells[homeColIndex].innerHTML.replace(
									/(Huntley)/gi,
									'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
								);
							}
						}
						
						// Check away team column
						if (awayColIndex >= 0 && awayColIndex < cells.length) {
							if (cells[awayColIndex].textContent.includes('Huntley')) {
								huntleyFound = true;
								cells[awayColIndex].innerHTML = cells[awayColIndex].innerHTML.replace(
									/(Huntley)/gi,
									'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
								);
							}
						}
						
						// Show/hide rows based on Huntley
						if (huntleyFound) {
							row.style.display = '';
							row.style.backgroundColor = '#3c0000'; // Dark red
							row.style.fontWeight = 'bold';
							
							// Make all cells in Huntley rows have white text
							for (let j = 0; j < cells.length; j++) {
								cells[j].style.color = 'white';
							}
						} else {
							row.style.display = 'none';
						}
					}
					
					// Apply styles to the table
					table.style.backgroundColor = '#1E1E1E';
					table.style.color = '#FFFFFF';
					table.style.borderCollapse = 'collapse';
					table.style.width = '100%';
					table.style.marginBottom = '20px';
					
					// Style all cells
					const allCells = table.querySelectorAll('td, th');
					allCells.forEach(function(cell) {
						cell.style.border = '1px solid #444';
						cell.style.padding = '12px';
						cell.style.fontSize = '16px';
					});
					
					// Style headers
					const headerCells = table.querySelectorAll('th');
					headerCells.forEach(function(cell) {
						cell.style.backgroundColor = '#333';
						cell.style.color = '#FFF';
						cell.style.fontWeight = 'bold';
						cell.style.fontSize = '18px';
						cell.style.textAlign = 'center';
					});
				});
				
				// Add a counter of visible games
				const visibleRows = document.querySelectorAll('tr:not([style*="display: none"])');
				const gameCount = visibleRows.length - document.querySelectorAll('tr th').length;
				
				const counterDiv = document.createElement('div');
				counterDiv.innerHTML = `<p style="text-align: center; font-size: 20px; margin: 20px 0; color: #fff; background-color: #3c0000; padding: 10px; border-radius: 5px; font-weight: bold;">Showing ${gameCount} Huntley games</p>`;
				document.body.insertBefore(counterDiv, document.body.firstChild);
			}
			
			// Style the entire page
			function stylePageForDarkMode() {
				// Hide unnecessary elements
				const elementsToHide = document.querySelectorAll('header, nav, #header, .header, footer, #footer, .footer, [id*="ad"], [class*="ad"], [id*="banner"], [class*="banner"]');
				elementsToHide.forEach(function(el) {
					el.style.display = 'none';
				});
				
				// Set dark background for all containers
				const containers = document.querySelectorAll('div, section, article, main');
				containers.forEach(function(el) {
					el.style.backgroundColor = '#121212';
					el.style.color = '#FFFFFF';
				});
				
				// Style links
				const links = document.querySelectorAll('a');
				links.forEach(function(link) {
					link.style.color = '#ff6b6b';
				});
				
				// Remove background images
				const elementsWithBg = document.querySelectorAll('[style*="background-image"]');
				elementsWithBg.forEach(function(el) {
					el.style.backgroundImage = 'none';
					el.style.backgroundColor = '#121212';
				});
				
				// Increase readability
				document.body.style.fontSize = '16px';
				document.body.style.lineHeight = '1.5';
				document.body.style.fontFamily = '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif';
			}
			
			// Apply styles and filtering
			stylePageForDarkMode();
			filterSchedulesForHuntley();
			
			// Run again after a delay to catch any dynamically loaded content
			setTimeout(filterSchedulesForHuntley, 1500);
			"""
			
			webView.evaluateJavaScript(javascript) { result, error in
				if let error = error {
					print("Dark mode JavaScript error: \(error)")
				} else {
					print("Dark mode JavaScript executed successfully")
				}
			}
		}
	}
}

// For WebViews that need to highlight Huntley games in schedules
struct ScheduleWebView: UIViewRepresentable {
	let url: URL
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.navigationDelegate = context.coordinator
		webView.load(URLRequest(url: url))
		return webView
	}
	
	func updateUIView(_ webView: WKWebView, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate {
		let parent: ScheduleWebView
		
		init(_ parent: ScheduleWebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			let javascript = """
			// Function to filter schedule tables for Huntley games only
			function filterHuntleyGames() {
				// Process all tables in the document
				const tables = document.querySelectorAll('table');
				tables.forEach(function(table) {
					// Get all rows in the table
					const rows = table.querySelectorAll('tr');
					
					// Find header row first to identify team columns
					let homeColIndex = -1;
					let awayColIndex = -1;
					
					// Find the header row and identify team column indices
					for (let i = 0; i < rows.length; i++) {
						const cells = rows[i].querySelectorAll('th, td');
						for (let j = 0; j < cells.length; j++) {
							const text = cells[j].textContent.trim().toLowerCase();
							if (text === 'home' || text === 'home team') {
								homeColIndex = j;
							} else if (text === 'away' || text === 'away team' || text === 'visitor') {
								awayColIndex = j;
							}
						}
						
						// If we found team columns, we can stop looking
						if (homeColIndex >= 0 || awayColIndex >= 0) break;
					}
					
					// If we couldn't identify columns specifically, use reasonable defaults
					if (homeColIndex < 0 && awayColIndex < 0) {
						// Many schedules have home/away teams around columns 2-4
						homeColIndex = 2;
						awayColIndex = 3;
					}
					
					// Now process data rows to hide/show and highlight based on team names
					for (let i = 0; i < rows.length; i++) {
						const row = rows[i];
						const cells = row.querySelectorAll('td');
						
						// Skip rows with no data cells (like headers)
						if (cells.length === 0) continue;
						
						let huntleyFound = false;
						
						// Check if "Huntley" is in either team column
						if (homeColIndex >= 0 && homeColIndex < cells.length) {
							if (cells[homeColIndex].textContent.includes("Huntley")) {
								huntleyFound = true;
								cells[homeColIndex].innerHTML = cells[homeColIndex].innerHTML.replace(
									/(Huntley)/gi,
									'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
								);
							}
						}
						
						if (awayColIndex >= 0 && awayColIndex < cells.length) {
							if (cells[awayColIndex].textContent.includes("Huntley")) {
								huntleyFound = true;
								cells[awayColIndex].innerHTML = cells[awayColIndex].innerHTML.replace(
									/(Huntley)/gi,
									'<span style="background-color: yellow; color: black; font-weight: bold;">$1</span>'
								);
							}
						}
						
						// Hide rows that don't contain Huntley in team columns
						if (!huntleyFound) {
							row.style.display = 'none';
						} else {
							// Make Huntley rows more visible
							row.style.backgroundColor = '#3c0000';
							row.style.color = 'white';
							row.style.fontWeight = 'bold';
						}
					}
				});
				
				// Apply dark mode styling
				document.body.style.backgroundColor = '#121212';
				document.body.style.color = '#FFFFFF';
				
				// Style tables
				const tables = document.querySelectorAll('table');
				tables.forEach(function(table) {
					table.style.backgroundColor = '#1E1E1E';
					table.style.color = '#FFFFFF';
					table.style.borderCollapse = 'collapse';
					table.style.width = '100%';
					table.style.marginBottom = '20px';
					
					const cells = table.querySelectorAll('td, th');
					cells.forEach(function(cell) {
						cell.style.border = '1px solid #333';
						cell.style.padding = '10px';
					});
				});
			}
			
			// Run the filtering function
			filterHuntleyGames();
			
			// Also run again after a delay to catch any dynamically loaded content
			setTimeout(filterHuntleyGames, 1000);
			"""
			
			webView.evaluateJavaScript(javascript) { result, error in
				if let error = error {
					print("JavaScript error: \(error)")
				}
			}
		}
	}
}
