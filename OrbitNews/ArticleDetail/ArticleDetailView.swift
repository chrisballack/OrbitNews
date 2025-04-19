//
//  ArticleDetailView.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import SwiftUI

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
