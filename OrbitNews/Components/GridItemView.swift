//
//  GridItemView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

/// A view that displays a single article item in a grid format.
///
/// - Parameters:
///   - article: An optional `ResultsArticles` object representing the article to display.
///   - onTap: A closure invoked when the user taps on the article item. It receives the tapped article as a parameter.
///
/// This view presents the article's image, title, author, publication date, and source in a compact grid layout.
/// The image is loaded asynchronously using `AsyncImageLoading`, and tapping on any part of the view triggers the `onTap` action.
/// Additionally, a share button is displayed if the article contains a valid URL.
///
/// - Important: Ensure that the `ResultsArticles` model is properly defined and contains the necessary properties (e.g., `image_url`, `title`, `authors`, etc.).
///              Also, ensure that `AsyncImageLoading` is implemented correctly to handle asynchronous image loading.
///
/// Example usage:
///
/// ```swift
/// GridItemView(
///     article: someArticle,
///     onTap: { article in
///         print("Tapped article: \(article?.title ?? "Unknown")")
///     }
/// )
/// ```
struct GridItemView: View {
    let article: ResultsArticles?
    let onTap: (ResultsArticles?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImageLoading(imageUrl: article?.image_url, width: nil, height: 120, cornerRadius: 8).onTapGesture {
                onTap(article)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                if let article = article {
                    
                    Text(article.news_site ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .bold()
                        .onTapGesture {
                            onTap(article)
                        }
                    
                    Text(article.title ?? "")
                        .font(.headline)
                        .lineLimit(3)
                        .onTapGesture {
                            onTap(article)
                        }
                    
                    if let autors = article.authors, autors.indices.contains(0) {
                        HStack(){
                            
                            Text("\(autors[0].name ?? "") • \(article.formattedPublishedAt ?? "")")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    onTap(article)
                                }
                            Spacer()
                            ShareLink(item: article.url ?? "") {
                                Image(systemName: "square.and.arrow.up")
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                            }
                            
                            
                        }
                        
                    }
                    
                }
            }.padding()
            
            
        }
        
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    GridItemView( article: nil, onTap: {_ in
        print("result")
    })
}
