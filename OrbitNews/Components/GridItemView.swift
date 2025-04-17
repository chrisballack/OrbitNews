//
//  GridItemView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

struct GridItemView: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(article.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .cornerRadius(8)
            
            Text(article.category)
                .font(.caption)
                .foregroundColor(.gray)
                .bold()
            
            Text(article.title)
                .font(.headline)
                .lineLimit(3)
            
            Text("\(article.author) • \(article.date)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    GridItemView(article: Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "firstclass"))
}
