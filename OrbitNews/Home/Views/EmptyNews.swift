//
//  EmptyNews.swift
//  OrbitNews
//
//  Created by Christians bonilla on 19/04/25.
//

import SwiftUI

/// A view that displays a placeholder message when no news articles are available.
///
/// - Parameters:
///   - withImage: A Boolean value indicating whether to display an image alongside the message.
///   - withbutton: A Boolean value indicating whether to include a retry button.
///   - Title: The title or message to display, typically explaining the empty state.
///   - onTapRetry: A closure invoked when the retry button is tapped.
///
/// This view is designed to handle scenarios where there are no news articles to display. It can optionally show an image and a retry button based on the provided parameters.
/// The layout centers the content vertically and horizontally within the available space.
///
/// - Note: Ensure that the image named `"notNews"` exists in your asset catalog if `withImage` is set to `true`.
///
/// Example usage:
///
/// ```swift
/// EmptyNews(
///     withImage: true,
///     withbutton: true,
///     Title: NSLocalizedString("No news available", comment: ""),
///     onTapRetry: {
///         print("Retry button tapped")
///     }
/// )
/// ```
struct EmptyNews: View {
    
    let withImage: Bool
    let withbutton: Bool
    let Title: String
    let onTapRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            if (withImage){
                Image("notNews")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
            
            
            Text(Title)
                .font(.title3)
                .foregroundColor(.gray)
            
            if (withbutton){
                Button(action: {
                    onTapRetry()
                }) {
                    Text(NSLocalizedString("Retry", comment: ""))
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyNews(withImage: true, withbutton: true, Title: NSLocalizedString("No news available", comment: ""), onTapRetry: {
        
        print("works")
        
    })
}
