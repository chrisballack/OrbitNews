//
//  ListItemView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 17/04/25.
//

import SwiftUI

/// A view that displays a single article item in a list format.
///
/// - Parameters:
///   - article: An optional `ResultsArticles` object representing the article to display.
///   - onTap: A closure invoked when the user taps on the article item. It receives the tapped article as a parameter.
///
/// This view presents the article's image, title, author, publication date, and source in a compact horizontal layout.
/// The image is loaded asynchronously using `AsyncImageLoading`, and tapping on any part of the view triggers the `onTap` action.
/// Additionally, a share button is displayed if the article contains a valid URL.
///
/// - Important: Ensure that the `ResultsArticles` model is properly defined and contains the necessary properties (e.g., `image_url`, `title`, `authors`, etc.).
///              Also, ensure that `AsyncImageLoading` is implemented correctly to handle asynchronous image loading.
///
/// Example usage:
///
/// ```swift
/// ListItemView(
///     article: someArticle,
///     onTap: { article in
///         print("Tapped article: \(article?.title ?? "Unknown")")
///     }
/// )
/// ```
struct ListItemView: View {
    
    let article: ResultsArticles?
    let onTap: (ResultsArticles?) -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            AsyncImageLoading(imageUrl: article?.image_url, width: 100, height: 80, cornerRadius: 8).onTapGesture {
                onTap(article ?? nil)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                
                if let article = article {
                    
                    Text(article.news_site ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .bold().onTapGesture {
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
                            if let url = article.url {
                                Spacer()
                                ShareLink(item: url) {
                                    Image(systemName: "square.and.arrow.up")
                                        .frame(width: 34, height: 34)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
        }
    }
}

#Preview {
    ListItemView(article: nil, onTap: {_ in 
        print("result")
    })
}
