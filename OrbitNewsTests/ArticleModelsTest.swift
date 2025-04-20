//
//  ArticleModelTest.swift
//  OrbitNewsTests
//
//  Created by Christians Bonilla on 20/04/25.
//

import Testing
@testable import OrbitNews
import Foundation

@Suite("ArticlesModelTests")
struct ArticlesModelTests {
    
    @Test("Invalid date format")
    func testInvalidDateFormat() async {
        let json = """
            {
                "id": 1,
                "published_at": "invalid-date"
            }
            """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let article = try? decoder.decode(ResultsArticles.self, from: json)
        assert(article?.published_at == nil, "Published date should be nil for invalid format")
    }
    
    @Test("Decode valid JSON")
    func testDecodeValidJSON() async {
        let json = """
        {
            "count": 10,
            "next": "https://example.com/next",
            "previous": null,
            "results": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let model = try? decoder.decode(ArticlesModel.self, from: json)
        
        assert(model?.count == 10, "Count should be 10")
        assert(model?.next == "https://example.com/next", "Next URL should match")
        assert(model?.previous == nil, "Previous should be nil")
        assert(model?.results?.isEmpty == true, "Results should be empty")
    }
    
    @Test("Handle missing fields")
    func testMissingFields() async {
        let json = "{}".data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let model = try? decoder.decode(ArticlesModel.self, from: json)
        
        assert(model?.count == nil, "Count should be nil when missing")
        assert(model?.next == nil, "Next should be nil when missing")
        assert(model?.previous == nil, "Previous should be nil when missing")
        assert(model?.results == nil, "Results should be nil when missing")
    }
}

@Suite("ResultsArticlesTests")
struct ResultsArticlesTests {
    @Test("Decode valid article")
    func testDecodeValidArticle() async {
        let json = """
        {
            "id": 1,
            "title": "Sample Title",
            "authors": [],
            "url": "https://example.com",
            "image_url": "https://example.com/image.jpg",
            "news_site": "Example News",
            "summary": "This is a summary.",
            "published_at": "2023-10-01T12:00:00Z",
            "updated_at": "2023-10-01T12:30:00Z",
            "featured": true,
            "launches": [],
            "events": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let article = try? decoder.decode(ResultsArticles.self, from: json)
        
        assert(article?.id == 1, "ID should be 1")
        assert(article?.title == "Sample Title", "Title should match")
        assert(article?.url == "https://example.com", "URL should match")
        assert(article?.formattedPublishedAt == "Oct, 01 2023", "Formatted date should match")
    }
    
    @Test("Handle optional fields")
    func testOptionalFields() async {
        let json = """
        {
            "id": 1
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let article = try? decoder.decode(ResultsArticles.self, from: json)
        
        assert(article?.title == nil, "Title should be nil when missing")
        assert(article?.authors == nil, "Authors should be nil when missing")
        assert(article?.published_at == nil, "Published date should be nil when missing")
    }
    
}

@Suite("AuthorsTests")
struct AuthorsTests {
    @Test("Decode valid author")
    func testDecodeValidAuthor() async {
        let json = """
        {
            "name": "John Doe",
            "socials": {
                "x": "https://twitter.com/johndoe",
                "youtube": "https://youtube.com/johndoe"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let author = try? decoder.decode(Authors.self, from: json)
        
        assert(author?.name == "John Doe", "Name should match")
        assert(author?.socials?.x == "https://twitter.com/johndoe", "X handle should match")
        assert(author?.socials?.youtube == "https://youtube.com/johndoe", "YouTube link should match")
    }
}

