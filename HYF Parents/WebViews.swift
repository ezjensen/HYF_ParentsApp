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

//A simple web view that allows navigation within the webview
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
		var parent: EnhancedWebView
		
		init(_ parent: EnhancedWebView) {
			self.parent = parent
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			let javascript = """
function showOnlyElement() {
 // Hide everything
 document.body.style.margin = '0';
 document.body.style.padding = '0';
 document.body.style.backgroundColor = '#121212'; // Dark background
 
 // Get the element we want to show
 var targetElement = document.getElementById('\(parent.divToShow)');
 
 if (targetElement) {
  // Hide all body children
  var children = document.body.children;
  for (var i = 0; i < children.length; i++) {
   children[i].style.display = 'none';
  }
  
  // Show only our target element
  targetElement.style.display = 'block';
  targetElement.style.width = '100%';
  targetElement.style.margin = '0 auto';
  
  // Mobile-friendly styling
  var styleElement = document.createElement('style');
  styleElement.textContent = `
   body {
 background-color: #121212;
 color: #f5f5f5;
 font-family: -apple-system, sans-serif;
 padding: 0;
 margin: 0;
   }
   table {
 width: 100% !important;
 border-collapse: collapse;
 margin: 10px 0;
 font-size: 14px;
 background-color: #1e1e1e;
   }
   th {
 background-color: #cc0000;
 color: white;
 padding: 8px 4px;
 font-size: 14px;
 text-align: center;
   }
   td {
 padding: 8px 4px;
 font-size: 14px;
 border-bottom: 1px solid #333;
 text-align: center;
 color: #f5f5f5;
   }
   .ui-tabs {
 border: none !important;
 background: transparent !important;
 padding: 0 !important;
   }
   .ui-tabs-nav {
 background: #222 !important;
 border: none !important;
 border-radius: 0 !important;
 display: flex !important;
 padding: 0 !important;
   }
   .ui-tabs-tab {
 background: #222 !important;
 border: none !important;
 margin: 0 !important;
 flex: 1 !important;
 float: none !important;
   }
   .ui-tabs-active {
 background: #cc0000 !important;
   }
   .ui-tabs-anchor {
 color: white !important;
 font-size: 14px !important;
 padding: 10px 5px !important;
 width: 100% !important;
 text-align: center !important;
 display: block !important;
 box-sizing: border-box !important;
 text-decoration: none !important;
   }
   #box5 {
 padding: 0 !important;
 width: 100% !important;
 background-color: #121212 !important;
   }
   .ui-tabs-panel {
 padding: 10px 5px !important;
 background-color: #1e1e1e !important;
   }
   /* Hide unnecessary content */
   img, br, b:empty { display: none !important; }
   /* Make text more readable */
   a { color: #ff9999 !important; text-decoration: none; }
   /* Team colors */
   .team-home { color: #ffcc00 !important; }
   .team-away { color: #ffffff !important; }
   /* Game status */
   .game-time { color: #00cc66 !important; }
  `;
  document.head.appendChild(styleElement);
  
  // Simplify tables for mobile viewing
  var tables = targetElement.querySelectorAll('table');
  tables.forEach(function(table) {
   // Make table 100% width
   table.style.width = '100%';
   table.style.backgroundColor = '#1e1e1e';
   
   // Remove all width attributes
   var cells = table.querySelectorAll('th, td');
   cells.forEach(function(cell) {
 cell.removeAttribute('width');
 cell.removeAttribute('bgcolor');
 
 // Simplify content in cells
 if (cell.textContent.trim() === 'vs') {
  cell.style.fontWeight = 'bold';
  cell.style.color = '#ff9999';
 }
 
 // Color for dates and times
 if (cell.textContent.includes('AM') || cell.textContent.includes('PM')) {
  cell.classList.add('game-time');
 }
   });
   
   // Add team highlighting
   var rows = table.querySelectorAll('tr');
   rows.forEach(function(row) {
 if (row.textContent.includes('Huntley')) {
  row.style.backgroundColor = 'rgba(204, 0, 0, 0.3)';
  row.style.fontWeight = 'bold';
  
  // Find the Huntley cell and make it stand out
  var cells = row.querySelectorAll('td');
  cells.forEach(function(cell) {
   if (cell.textContent.includes('Huntley')) {
 cell.style.color = '#ffffff';
 cell.style.fontWeight = 'bold';
 cell.style.textShadow = '0 0 2px #cc0000';
   }
  });
 }
   });
  });
  
  // Tabs - make more touch-friendly
  var tabs = targetElement.querySelectorAll('.ui-tabs-anchor');
  tabs.forEach(function(tab) {
   tab.style.textDecoration = 'none';
  });
  
  // Append it directly to body
  document.body.appendChild(targetElement);
 }
}
showOnlyElement();
"""
			
			webView.evaluateJavaScript(javascript, completionHandler: nil)
		}
	}
}
