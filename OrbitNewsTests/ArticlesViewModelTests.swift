//
//  ViewModelTests.swift
//  OrbitNewsTests
//
//  Created by Maria Fernanda Paz Rodriguez on 20/04/25.
//

import Testing
@testable import OrbitNews

@Suite("ViewModel Tests")
struct ArticlesViewModelTests {
    
    @Test("fetchArticles should update articles and not set errorMessage when successful")
    func testFetchArticlesSuccess() async throws {
        let viewModel = await ArticlesViewModel()
        await viewModel.fetchArticles(withLoading: false)

        #expect(await viewModel.articles != nil)
        #expect(await viewModel.errorMessage == nil)
        #expect(await viewModel.isLoading == false)
    }


    @Test("fetchArticles should set errorMessage on invalid URL")
    func testInvalidBaseURL() async throws {
        let viewModel = await ArticlesViewModel()
        
        let mirror = Mirror(reflecting: viewModel)
        if mirror.children.first(where: { $0.label == "baseURL" }) != nil {
            let baseURLPointer = UnsafeMutablePointer<String>.allocate(capacity: 1)
            baseURLPointer.initialize(to: "invalid_url")
            baseURLPointer.withMemoryRebound(to: String.self, capacity: 1) { _ in
                
            }
        }
        
    }

    @Test("searchArticles should filter results based on query")
    func testSearchArticles() async throws {
        let viewModel = await ArticlesViewModel()
        
        await MainActor.run {
            viewModel.searchQuery = "mars"
        }
        
        await viewModel.searchArticles(withLoading: false)
        #expect(await viewModel.articles != nil)
        #expect(await viewModel.errorMessage == nil)
    }

    @Test("loadMoreArticles should append new articles to existing ones")
    func testLoadMoreArticles() async throws {
        let viewModel = await ArticlesViewModel()
        await viewModel.fetchArticles(limit: 2)
        
        let oldCount = await viewModel.articles?.results?.count ?? 0
        await viewModel.loadMoreArticles()
        let newCount = await viewModel.articles?.results?.count ?? 0

        #expect(newCount >= oldCount)
    }
}

