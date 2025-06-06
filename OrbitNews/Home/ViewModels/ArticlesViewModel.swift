//
//  ArticlesViewModel.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import Foundation
import Combine

/// A view model responsible for managing and fetching articles from a remote API.
///
/// - Note: This class conforms to `ObservableObject` and is designed to be used with SwiftUI views.
///         It uses `@Published` properties to notify the UI of changes in the data, loading state, or error messages.
///
/// - Properties:
///   - articles: The fetched articles data, represented as an optional `ArticlesModel`.
///   - isLoading: A Boolean value indicating whether a network request is currently in progress.
///   - errorMessage: An optional string containing an error message if a network or decoding error occurs.
///
/// This view model provides two main methods for fetching articles:
/// - `fetchArticles(limit:url:)`: Fetches a specified number of articles from the API, sorted by publication date in descending order.
/// - `loadMoreArticles()`: Loads additional articles from the API, appending them to the existing list.
///
/// - Important: Ensure that the `ArticlesModel` and related data models are properly defined and conform to `Decodable`.
///              Additionally, the API endpoint should be valid and accessible.
///
/// Example usage:
///
/// ```swift
/// let viewModel = ArticlesViewModel()
/// Task {
///     await viewModel.fetchArticles(limit: 10)
/// }
/// ```
@MainActor
class ArticlesViewModel: ObservableObject {
    @Published var articles: ArticlesModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    
    private let baseURL = "https://api.spaceflightnewsapi.net/v4/articles"
    
    func fetchArticles(limit: Int = 5, search: String? = nil , withLoading: Bool = false) async {
        isLoading = withLoading
        errorMessage = nil
        
        guard var components = URLComponents(string: baseURL) else {
            errorMessage = "Invalid base URL"
            isLoading = false
            return
        }
        
        var queryItems = [
            URLQueryItem(name: "_limit", value: "\(limit)"),
            URLQueryItem(name: "_sort", value: "publishedAt:desc")
        ]
        
        if let search = search, !search.trimmingCharacters(in: .whitespaces).isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            errorMessage = "Failed to construct URL"
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
        guard !isLoading, let nextUrl = articles?.next, let url = URL(string: nextUrl) else {
            return
        }
        
        
        errorMessage = nil
        
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
        
    }
    
    func searchArticles( withLoading: Bool = false) async {
        await fetchArticles(limit: articles?.results?.count ?? 5, search: searchQuery,withLoading:withLoading)
    }
}
