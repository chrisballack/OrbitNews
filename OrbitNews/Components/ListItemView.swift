//
//  ListItemView.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 17/04/25.
//

import SwiftUI

struct ListItemView: View {
    
    let article: Article
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(article.imageName)
                .resizable()
                .frame(width: 100, height: 80)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
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
        }
    }
}

#Preview {
    ListItemView(article: Article(category: "Business", title: "Why it’s gotten more difficult to get a free first-class upgrade Why it’s gotten more difficult to get a free first-class upgrade", author: "Antonio Botosh", date: "Dec 11, 2024", imageName: "firstclass"))
}
