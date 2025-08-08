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
		Coordinator(self)
	}
	
	class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
		var parent: EnhancedWebView
		private let fieldService = FieldService()
		private var fields: [Field]? = nil
		
		init(_ parent: EnhancedWebView) {
			self.parent = parent
			super.init()
			// Pre-fetch fields when coordinator is initialized
			loadFields()
		}
		
		private func loadFields() {
			let fieldService = FieldService()
			fieldService.fetchFields()
			self.fields = fieldService.fields
			print("Successfully loaded \(fieldService.fields.count) fields from static data")
		}
		
		// Handle messages from JavaScript
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
					if let fields = self.fields {
						// Convert fields to JSON
						do {
							let encoder = JSONEncoder()
							let fieldsData = try encoder.encode(fields)
							if let fieldsJson = String(data: fieldsData, encoding: .utf8) {
								// Send fields data to JavaScript
								let script = "receiveFieldsData('\(fieldsJson.replacingOccurrences(of: "'", with: "\\'"))');"
								webView.evaluateJavaScript(script)
							}
						} catch {
							print("Error encoding fields: \(error.localizedDescription)")
							sendHardcodedFields(to: webView)
						}
					} else {
						// No fields data available, use hardcoded fallback
						sendHardcodedFields(to: webView)
					}
				}
			}
		}
		
		private func sendHardcodedFields(to webView: WKWebView) {
			// Create a field service instance to access the fields
			let fieldService = FieldService()
			fieldService.fetchFields()
			
			do {
				let encoder = JSONEncoder()
				encoder.outputFormatting = .prettyPrinted
				let data = try encoder.encode(fieldService.fields)
				
				if let jsonString = String(data: data, encoding: .utf8) {
					print("Sending \(fieldService.fields.count) fields to WebView")
					let script = "fieldsData = \(jsonString); checkDataAndRender();"
					
					webView.evaluateJavaScript(script) { result, error in
						if let error = error {
							print("Error sending fields data: \(error)")
						} else {
							print("Fields data sent successfully")
						}
					}
				}
			} catch {
				print("Failed to encode fields: \(error)")
			}
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			// Check URL to determine which JavaScript to apply
			if parent.url.absoluteString.contains("maps.php") {
				applyFieldsJavaScript(webView)
			} else if parent.url.absoluteString.contains("TabbedGameSchedulesNEW.php") {
				applyScheduleJavaScript(webView)
			} else {
				applyDarkModeJavaScript(webView)
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
					// This function might still be called from Swift
					fieldsData = fieldsJSON;
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
					// Don't wait for image, proceed with rendering
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
				
				
				// Create a card for each field
				var fieldsList = document.createElement('div');
				fieldsData.forEach(function(field) {
					var fieldCard = document.createElement('div');
					fieldCard.style.backgroundColor = '#1e1e1e';
					fieldCard.style.padding = '22px';
					fieldCard.style.marginBottom = '18px';
					fieldCard.style.borderRadius = '12px';
					fieldCard.style.cursor = 'pointer';
					fieldCard.style.position = 'relative';
					
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
					}
					
					// Field name (tappable)
					var fieldName = document.createElement('h2');
					fieldName.textContent = field.name;
					fieldName.style.color = 'white';
					fieldName.style.marginBottom = '12px';
					fieldName.style.fontSize = '34px';
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
					fieldAddress.style.fontSize = '24px';
					fieldAddress.style.lineHeight = '1.4';
					fieldCard.appendChild(fieldAddress);
					
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
						h2 { font-size: 30px; }
						p { font-size: 22px; }
					}
				`;
				document.head.appendChild(style);
				
				// Replace page content with our list
				document.body.appendChild(container);
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
		
		private func applyDarkModeJavaScript(_ webView: WKWebView) {
			let javascript = """
			// Apply dark mode to generic TCYFL pages
			document.body.style.backgroundColor = '#121212';
			document.body.style.color = '#ffffff';
			
			// Add global styles for dark mode
			var style = document.createElement('style');
			style.textContent = `
				body {
					background-color: #121212 !important;
					color: #dddddd !important;
					font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
				}
				a { color: #cc0000 !important; }
				table, th, td { 
					border-color: #333333 !important;
					background-color: #1e1e1e !important;
					color: #dddddd !important;
				}
				div, section { background-color: #121212 !important; }
				input, select { 
					background-color: #333333 !important; 
					color: #ffffff !important;
					border: 1px solid #555555 !important;
				}
			`;
			document.head.appendChild(style);
			"""
			
			webView.evaluateJavaScript(javascript)
		}
		
		private func applyScheduleJavaScript(_ webView: WKWebView) {
			let javascript = """
			// Enhance the schedule display
			document.body.style.backgroundColor = '#121212';
			document.body.style.color = '#ffffff';
			
			// Preserve the division selection functionality
			var formElement = document.querySelector('form');
			var selectElement = document.querySelector('select[name="division"]');
			var submitButton = document.querySelector('input[type="submit"]');
			
			// Find the schedule table
			var scheduleDiv = document.getElementById('box5');
			if (scheduleDiv) {
				// Extract the schedule content
				var scheduleContent = scheduleDiv.innerHTML;
				
				// Clear the page and create our own container
				document.body.innerHTML = '';
				var container = document.createElement('div');
				container.style.padding = '15px';
				container.style.backgroundColor = '#121212';
				
				// Recreate the division selection form with modern styling
				if (formElement && selectElement) {
					var formContainer = document.createElement('div');
					formContainer.style.marginBottom = '25px';
					formContainer.style.padding = '15px';
					formContainer.style.backgroundColor = '#1e1e1e';
					formContainer.style.borderRadius = '12px';
					formContainer.style.display = 'flex';
					formContainer.style.flexDirection = 'column';
					formContainer.style.gap = '15px';
					
					var label = document.createElement('div');
					label.textContent = 'Select Division:';
					label.style.color = '#ffffff';
					label.style.fontWeight = 'bold';
					label.style.fontSize = '20px';
					formContainer.appendChild(label);
					
					var newForm = document.createElement('form');
					newForm.method = formElement.method;
					newForm.action = formElement.action;
					
					// Get all the hidden inputs from the original form
					var hiddenInputs = formElement.querySelectorAll('input[type="hidden"]');
					hiddenInputs.forEach(function(input) {
						var newInput = document.createElement('input');
						newInput.type = 'hidden';
						newInput.name = input.name;
						newInput.value = input.value;
						newForm.appendChild(newInput);
					});
					
					// Recreate the select with better styling
					var newSelect = document.createElement('select');
					newSelect.name = selectElement.name;
					newSelect.style.backgroundColor = '#333333';
					newSelect.style.color = '#ffffff';
					newSelect.style.padding = '12px';
					newSelect.style.borderRadius = '8px';
					newSelect.style.border = '1px solid #555555';
					newSelect.style.fontSize = '18px';
					newSelect.style.width = '100%';
					newSelect.style.marginBottom = '15px';
					
					// Copy all options
					Array.from(selectElement.options).forEach(function(option) {
						var newOption = document.createElement('option');
						newOption.value = option.value;
						newOption.textContent = option.textContent;
						if (option.selected) {
							newOption.selected = true;
						}
						newSelect.appendChild(newOption);
					});
					
					newForm.appendChild(newSelect);
					
					// Recreate the submit button with better styling
					var newSubmit = document.createElement('input');
					newSubmit.type = 'submit';
					newSubmit.value = submitButton ? submitButton.value : 'Update';
					newSubmit.style.backgroundColor = '#cc0000';
					newSubmit.style.color = '#ffffff';
					newSubmit.style.padding = '12px 20px';
					newSubmit.style.border = 'none';
					newSubmit.style.borderRadius = '8px';
					newSubmit.style.fontSize = '18px';
					newSubmit.style.fontWeight = 'bold';
					newSubmit.style.cursor = 'pointer';
					newSubmit.style.alignSelf = 'flex-start';
					
					// Add a nice hover effect
					newSubmit.onmouseover = function() {
						this.style.backgroundColor = '#aa0000';
					};
					newSubmit.onmouseout = function() {
						this.style.backgroundColor = '#cc0000';
					};
					
					newForm.appendChild(newSubmit);
					formContainer.appendChild(newForm);
					
					// Add the form container to the main container
					container.appendChild(formContainer);
				}
				
				// Add the schedule content
				var scheduleContainer = document.createElement('div');
				scheduleContainer.innerHTML = scheduleContent;
				container.appendChild(scheduleContainer);
				
				// Add styles for dark mode and better readability
				var style = document.createElement('style');
				style.textContent = `
					body {
						background-color: #121212 !important;
						color: #dddddd !important;
						font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
						font-size: 18px !important;
					}
					table { 
						width: 100% !important;
						border-collapse: collapse !important;
						margin-bottom: 20px !important;
						border-radius: 8px !important;
						overflow: hidden !important;
					}
					th { 
						background-color: #cc0000 !important; 
						color: white !important;
						padding: 12px 8px !important;
						font-size: 18px !important;
						text-align: left !important;
					}
					td { 
						background-color: #1e1e1e !important; 
						color: #dddddd !important;
						padding: 12px 8px !important;
						font-size: 18px !important;
						border-bottom: 1px solid #333333 !important;
					}
					tr:hover td { 
						background-color: #333333 !important; 
					}
					select, input {
						background-color: #333333 !important;
						color: white !important;
						border: 1px solid #555555 !important;
						padding: 10px !important;
						font-size: 16px !important;
						border-radius: 8px !important;
						-webkit-appearance: none !important;
					}
					select {
						background-image: url("data:image/svg+xml;charset=US-ASCII,<svg width='10' height='5' viewBox='0 0 10 5' fill='none' xmlns='http://www.w3.org/2000/svg'><path d='M0 0L5 5L10 0H0Z' fill='white'/></svg>") !important;
						background-repeat: no-repeat !important;
						background-position: right 10px center !important;
						padding-right: 30px !important;
					}
					a { color: #cc0000 !important; }
					.button, input[type="submit"], input[type="button"] {
						background-color: #cc0000 !important;
						color: white !important;
						border: none !important;
						padding: 12px 20px !important;
						border-radius: 8px !important;
						cursor: pointer !important;
						font-weight: bold !important;
						transition: background-color 0.2s !important;
					}
					.button:hover, input[type="submit"]:hover, input[type="button"]:hover {
						background-color: #aa0000 !important;
					}
					h1, h2, h3 {
						color: white !important;
					}
				`;
				document.head.appendChild(style);
				
				// Remove width constraints
				var tables = document.querySelectorAll('table');
				tables.forEach(function(table) {
					table.removeAttribute('width');
					table.style.width = '100%';
				});
				
				// Make Huntley teams highlighted
				var cells = document.querySelectorAll('td');
				cells.forEach(function(cell) {
					if (cell.textContent.includes('Huntley')) {
						cell.style.fontWeight = 'bold';
						cell.style.color = '#ffffff';
						cell.style.borderLeft = '4px solid #cc0000';
					}
				});
				
				// Replace page content with our enhanced version
				document.body.appendChild(container);
			}
			"""
			
			webView.evaluateJavaScript(javascript) { result, error in
				if let error = error {
					print("JavaScript error: \(error)")
				} else {
					print("Schedule JavaScript executed successfully")
				}
			}
		}
	}
}
