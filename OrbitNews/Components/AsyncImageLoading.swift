//
//  AsyncImageLoading.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import SwiftUI

/// A view that asynchronously loads and displays an image from a URL, with support for placeholders and error handling.
///
/// - Parameters:
///   - imageUrl: An optional string representing the URL of the image to load. If `nil`, a default image is displayed.
///   - width: An optional `CGFloat` value specifying the width of the image frame. If `nil`, the width is not constrained.
///   - height: A required `CGFloat` value specifying the height of the image frame.
///   - cornerRadius: A `CGFloat` value specifying the corner radius to apply to the image for rounded corners.
///
/// This view uses `AsyncImage` to load the image asynchronously. While the image is loading, a progress indicator is displayed.
/// If the image fails to load, a default placeholder image is shown. The image is resized and styled according to the provided dimensions and corner radius.
///
/// - Important: Ensure that the `defaultImage` asset exists in your asset catalog to handle cases where the image URL is invalid or loading fails.
///              Additionally, ensure that the `ImageFrameModifier` is implemented correctly to apply the desired frame constraints.
///
/// Example usage:
///
/// ```swift
/// AsyncImageLoading(
///     imageUrl: "https://example.com/image.jpg",
///     width: 150,
///     height: 100,
///     cornerRadius: 8
/// )
/// ```
struct AsyncImageLoading: View {
    let imageUrl: String?
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        Group {
            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .modifier(ImageFrameModifier(width: width, height: height))
                    case .success(let image):
                        image
                            .resizable()
                        
                            .modifier(ImageFrameModifier(width: width, height: height))
                            .cornerRadius(cornerRadius)
                    case .failure:
                        Image("defaultImage")
                            .resizable()
                        
                            .modifier(ImageFrameModifier(width: width, height: height))
                            .cornerRadius(cornerRadius)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image("defaultImage")
                    .resizable()
                
                    .modifier(ImageFrameModifier(width: width, height: height))
                    .cornerRadius(cornerRadius)
            }
        }
    }
}

/// A custom view modifier that applies a fixed frame to a view, optionally specifying its width and height.
///
/// - Parameters:
///   - width: An optional `CGFloat` value specifying the width of the frame. If `nil`, the width is not constrained.
///   - height: A required `CGFloat` value specifying the height of the frame.
///
/// This modifier adjusts the frame of the view it is applied to, ensuring a consistent size for layout purposes.
/// If a width is provided, the view will have both a fixed width and height. Otherwise, only the height is constrained.
///
/// Example usage:
///
/// ```swift
/// Image("example")
///     .modifier(ImageFrameModifier(width: 100, height: 50))
/// ```
struct ImageFrameModifier: ViewModifier {
    let width: CGFloat?
    let height: CGFloat

    func body(content: Content) -> some View {
        if let width = width {
            content.frame(width: width, height: height)
        } else {
            content.frame(height: height)
        }
    }
}

