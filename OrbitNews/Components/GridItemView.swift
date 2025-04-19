//
//  GridItemView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI


struct GridItemView: View {
    let article: ResultsArticles?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImageLoading(imageUrl: article?.image_url, width: nil, height: 120, cornerRadius: 8)
            
            VStack(alignment: .leading, spacing: 6) {
                if let article = article {
                    
                    Text(article.news_site ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .bold()
                    
                    Text(article.title ?? "")
                        .font(.headline)
                        .lineLimit(3)
                    
                    if let autors = article.authors, autors.indices.contains(0) {
                        HStack(){
                            
                            Text("\(autors[0].name ?? "") • \(article.formattedPublishedAt ?? "")")
                                .font(.caption)
                                .foregroundColor(.gray)
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
    }
}

#Preview {
    GridItemView( article: nil)
}
