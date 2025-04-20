//
//  OrbitNewsTests.swift
//  OrbitNewsTests
//
//  Created by Christians bonilla on 17/04/25.
//

import Testing
@testable import OrbitNews

@Suite("SQLManager Tests")
struct SQLManagerTests {
    
    

    @Test("Insert a favorite article")
    func testInsertFavorite() throws {
        let manager = SQLManager()
        
        let article = ResultsArticles(
            id: 1,
            title: "Test Insert",
            authors: [Authors(name: "chris", socials: Socials(x: "https://x.com/mercadolibre?lang=es", youtube: "https://www.youtube.com/user/mercadolibre", instagram: "https://www.instagram.com/mercadolibre.co/?hl=es", linkedin: "https://www.linkedin.com/company/mercadolibre/?originalSubdomain=co", mastodon: "", bluesky: ""))],
            url: "https://test.com",
            image_url: "https://test.com/image.jpg",
            news_site: "Test Site",
            summary: "Insert test summary",
            published_at: .now,
            updated_at: "2025-04-20T12:00:00Z",
            featured: true,
            launches: nil,
            events: nil,
            isFavorite: true
        )
        
        manager.insertFavorites(article: article)
        
        #expect(manager.favorites.contains(where: { $0.id == article.id }))
    }

    @Test("Delete a favorite article")
    func testDeleteFavorite() throws {
        let manager = SQLManager()
        
        let article = ResultsArticles(
            id: 2,
            title: "Test Delete",
            authors: [Authors(name: "chris", socials: Socials(x: "https://x.com/mercadolibre?lang=es", youtube: "https://www.youtube.com/user/mercadolibre", instagram: "https://www.instagram.com/mercadolibre.co/?hl=es", linkedin: "https://www.linkedin.com/company/mercadolibre/?originalSubdomain=co", mastodon: "", bluesky: ""))],
            url: "https://delete.com",
            image_url: "https://delete.com/image.jpg",
            news_site: "Delete Site",
            summary: "Delete test summary",
            published_at: .now,
            updated_at: "2025-04-20T12:00:00Z",
            featured: false,
            launches: nil,
            events: nil,
            isFavorite: true
        )
        
        manager.insertFavorites(article: article)
        manager.deleteFavorite(by: 2)
        
        #expect(!manager.favorites.contains(where: { $0.id == article.id }))
    }

    @Test("Search for a favorite article")
    func testSearchFavorite() throws {
        let manager = SQLManager()
        
        let article = ResultsArticles(
            id: 3,
            title: "Swift Testing Search",
            authors: [Authors(name: "chris", socials: Socials(x: "https://x.com/mercadolibre?lang=es", youtube: "https://www.youtube.com/user/mercadolibre", instagram: "https://www.instagram.com/mercadolibre.co/?hl=es", linkedin: "https://www.linkedin.com/company/mercadolibre/?originalSubdomain=co", mastodon: "", bluesky: ""))],
            url: "https://search.com",
            image_url: "https://search.com/image.jpg",
            news_site: "Search Site",
            summary: "Search test summary",
            published_at: .now,
            updated_at: "2025-04-20T12:00:00Z",
            featured: false,
            launches: nil,
            events: nil,
            isFavorite: true
        )
        
        manager.insertFavorites(article: article)
        manager.searchFavorites(by: "Swift")
        
        #expect(manager.favorites.contains(where: {
            ($0.title ?? "").contains("Swift")
        }))

    }
    
    @Test("Fetch a favorite article by ID")
    func testFetchArticleByID() throws {
        let manager = SQLManager()
        
        let article = ResultsArticles(
            id: 4,
            title: "Fetch Test Article",
            authors: [Authors(name: "chris", socials: Socials(x: "https://x.com/mercadolibre?lang=es", youtube: "https://www.youtube.com/user/mercadolibre", instagram: "https://www.instagram.com/mercadolibre.co/?hl=es", linkedin: "https://www.linkedin.com/company/mercadolibre/?originalSubdomain=co", mastodon: "", bluesky: ""))],
            url: "https://fetch.com",
            image_url: "https://fetch.com/image.jpg",
            news_site: "Fetch Site",
            summary: "Fetch test summary",
            published_at: .now,
            updated_at: "2025-04-20T12:00:00Z",
            featured: true,
            launches: nil,
            events: nil,
            isFavorite: true
        )
        
        manager.insertFavorites(article: article)
        
        let fetched = manager.fetchArticle(by: 4)
        
        #expect(fetched != nil)
        #expect(fetched?.id == article.id)
        #expect(fetched?.title == article.title)
    }
}
