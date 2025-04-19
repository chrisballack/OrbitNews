//
//  ArticlesModel.swift
//  OrbitNews
//
//  Created by Christians bonilla on 18/04/25.
//

import Foundation


struct ArticlesModel : Codable {
    let count : Int?
    var next : String?
    let previous : String?
    var results : [ResultsArticles]?
    
    enum CodingKeys: String, CodingKey {
        
        case count = "count"
        case next = "next"
        case previous = "previous"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        next = try values.decodeIfPresent(String.self, forKey: .next)
        previous = try values.decodeIfPresent(String.self, forKey: .previous)
        results = try values.decodeIfPresent([ResultsArticles].self, forKey: .results)
    }
    
}


struct ResultsArticles: Codable, Identifiable {
    let id: Int
    let title: String?
    let authors: [Authors]?
    let url: String?
    let image_url: String?
    let news_site: String?
    let summary: String?
    let published_at: Date?
    let updated_at: String?
    let featured: Bool?
    let launches: [Launches]?
    let events: [Events]?
    var isFavorite: Bool = false
    
    
    enum CodingKeys: String, CodingKey {
        case id, title, authors, url, image_url, news_site, summary, published_at, updated_at, featured, launches, events
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? UUID().hashValue
        title = try values.decodeIfPresent(String.self, forKey: .title)
        authors = try values.decodeIfPresent([Authors].self, forKey: .authors)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
        news_site = try values.decodeIfPresent(String.self, forKey: .news_site)
        summary = try values.decodeIfPresent(String.self, forKey: .summary)
        
        if let dateString = try values.decodeIfPresent(String.self, forKey: .published_at) {
            let isoFormatter = ISO8601DateFormatter()
            published_at = isoFormatter.date(from: dateString)
        } else {
            published_at = nil
        }
        
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        featured = try values.decodeIfPresent(Bool.self, forKey: .featured)
        launches = try values.decodeIfPresent([Launches].self, forKey: .launches)
        events = try values.decodeIfPresent([Events].self, forKey: .events)
    }
    
    init(
        id: Int = UUID().hashValue,
        title: String? = nil,
        authors: [Authors]? = nil,
        url: String? = nil,
        image_url: String? = nil,
        news_site: String? = nil,
        summary: String? = nil,
        published_at: Date? = nil,
        updated_at: String? = nil,
        featured: Bool? = nil,
        launches: [Launches]? = nil,
        events: [Events]? = nil,
        isFavorite:Bool
    ) {
        self.id = id
        self.title = title
        self.authors = authors
        self.url = url
        self.image_url = image_url
        self.news_site = news_site
        self.summary = summary
        self.published_at = published_at
        self.updated_at = updated_at
        self.featured = featured
        self.launches = launches
        self.events = events
        self.isFavorite = isFavorite
    }
    
    
    var formattedPublishedAt: String? {
        guard let date = published_at else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}


struct Authors : Codable {
    let name : String?
    let socials : Socials?
    
    enum CodingKeys: String, CodingKey {
        
        case name = "name"
        case socials = "socials"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        socials = try values.decodeIfPresent(Socials.self, forKey: .socials)
    }
    
}

struct Socials : Codable {
    let x : String?
    let youtube : String?
    let instagram : String?
    let linkedin : String?
    let mastodon : String?
    let bluesky : String?
    
    enum CodingKeys: String, CodingKey {
        
        case x = "x"
        case youtube = "youtube"
        case instagram = "instagram"
        case linkedin = "linkedin"
        case mastodon = "mastodon"
        case bluesky = "bluesky"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        x = try values.decodeIfPresent(String.self, forKey: .x)
        youtube = try values.decodeIfPresent(String.self, forKey: .youtube)
        instagram = try values.decodeIfPresent(String.self, forKey: .instagram)
        linkedin = try values.decodeIfPresent(String.self, forKey: .linkedin)
        mastodon = try values.decodeIfPresent(String.self, forKey: .mastodon)
        bluesky = try values.decodeIfPresent(String.self, forKey: .bluesky)
    }
    
}


struct Launches : Codable {
    let launch_id : String?
    let provider : String?
    
    enum CodingKeys: String, CodingKey {
        
        case launch_id = "launch_id"
        case provider = "provider"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        launch_id = try values.decodeIfPresent(String.self, forKey: .launch_id)
        provider = try values.decodeIfPresent(String.self, forKey: .provider)
    }
    
}

struct Events : Codable {
    let event_id : Int?
    let provider : String?
    
    enum CodingKeys: String, CodingKey {
        
        case event_id = "event_id"
        case provider = "provider"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        event_id = try values.decodeIfPresent(Int.self, forKey: .event_id)
        provider = try values.decodeIfPresent(String.self, forKey: .provider)
    }
    
}
