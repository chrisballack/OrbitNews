//
//  ArticlesViewModel.swift
//  OrbitNews
//
//  Created by Maria Fernanda Paz Rodriguez on 18/04/25.
//

import Foundation
import Combine


@MainActor
class ArticlesViewModel: ObservableObject {
    @Published var articles: ArticlesModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func fetchArticles(limit: Int = 5, url: String = "https://api.spaceflightnewsapi.net/v4/articles") async {
        isLoading = true
        errorMessage = nil
        
        let urlString = url + "?_limit=\(limit)&_sort=publishedAt:desc"
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(ArticlesModel.self, from: data)
            articles = decoded
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMoreArticles() async {
        guard !isLoading, let nextUrl = articles?.next else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: nextUrl) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let newArticlesBatch = try JSONDecoder().decode(ArticlesModel.self, from: data)
            
            if var currentArticles = articles {
                currentArticles.results?.append(contentsOf: newArticlesBatch.results ?? [])
                currentArticles.next = newArticlesBatch.next
                articles = currentArticles
            } else {
                articles = newArticlesBatch
            }
        } catch {
            
            errorMessage = error.localizedDescription
            
        }
        
        isLoading = false
    }
}
