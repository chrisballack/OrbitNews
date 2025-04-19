//
//  ListItemView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

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
