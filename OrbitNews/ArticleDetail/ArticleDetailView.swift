//
//  ArticleDetailView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import SwiftUI

/// A view that displays the detailed content of an article, including a web view for the article's URL, and provides actions for sharing and favoriting.
///
/// - Parameters:
///   - article: An optional `ResultsArticles` object representing the article to display. If `nil`, a placeholder message is shown.
///   - onDonePress: A closure invoked when the user taps the "Done" button to dismiss the view.
///   - onFavoritePress: A closure invoked when the user taps the favorite button to toggle the article's favorite status.
///
/// This view embeds a `WebView` to display the article's content from its URL. It also includes toolbar buttons for sharing the article,
/// toggling its favorite status, and dismissing the view. The favorite status is visually represented by a filled or outlined heart icon.
///
/// - Important: Ensure that the `ResultsArticles` model contains the necessary properties (e.g., `url`, `isFavorite`) and that the `WebView`
///              component is implemented correctly to handle web content. Additionally, ensure that the `ShareLink` feature is supported in your environment.
///
/// Example usage:
///
/// ```swift
/// ArticleDetailView(
///     article: someArticle,
///     onDonePress: {
///         print("User dismissed the article detail view")
///     },
///     onFavoritePress: {
///         print("User toggled the favorite status")
///     }
/// )
/// ```
struct ArticleDetailView: View {
    
    let article: ResultsArticles?
    var onDonePress: () -> Void
    var onFavoritePress: () -> Void
    @State private var isFavorite: Bool
    
    init(article: ResultsArticles?, onDonePress: @escaping () -> Void,onFavoritePress: @escaping () -> Void) {
        
        self.article = article ?? nil
        self._isFavorite = State(initialValue: article?.isFavorite ?? false)
        self.onDonePress = onDonePress
        self.onFavoritePress = onFavoritePress
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let url = URL(string: article?.url ?? "") {
                    WebView(url: url)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text(NSLocalizedString("Invalid URL", comment: ""))
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(NSLocalizedString("Article", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 6) {
                        
                        Button(action: {
                            isFavorite.toggle()
                            onFavoritePress()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .frame(width: 34, height: 34)
                                .foregroundColor(isFavorite ? .red : .gray)
                        }
                        
                        ShareLink(item: article?.url ?? "") {
                            Image(systemName: "square.and.arrow.up")
                                .frame(width: 34, height: 34)
                                .foregroundColor(.blue)
                        }
                        
                        Button(NSLocalizedString("Done", comment: "")) {
                            
                            onDonePress()
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
}



#Preview {
    ArticleDetailView(article:nil,
                      onDonePress: {
        print("onDonePress")
    }, onFavoritePress: {
        print("onFavoritePress")
    })
}
