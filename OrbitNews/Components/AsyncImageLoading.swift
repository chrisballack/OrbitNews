//
//  AsyncImageLoading.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 18/04/25.
//

import SwiftUI

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

