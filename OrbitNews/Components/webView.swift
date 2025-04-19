//
//  webView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import SwiftUI
import WebKit

/// A SwiftUI view that wraps a `WKWebView` to display web content.
///
/// - Parameter url: The URL of the web page to load and display.
///
/// This view conforms to `UIViewRepresentable`, allowing it to integrate a UIKit `WKWebView` into SwiftUI.
/// It provides the necessary methods to create, update, and manage the web view's lifecycle.
///
/// - Important: Ensure that the provided `url` is valid and accessible. Additionally, the `Coordinator` class
///              can be extended to handle navigation events or other delegate methods of `WKWebView`.
///
/// Example usage:
///
/// ```swift
/// if let url = URL(string: "https://www.example.com") {
///     WebView(url: url)
/// }
/// ```
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        
    }
}
