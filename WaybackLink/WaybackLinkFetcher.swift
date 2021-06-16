//
//  WaybackLinkFetcher.swift
//  WaybackLink
//
//  Created by teo on 15/06/2021.
//

import Foundation

// model from
/*
 {
    "url": "https://www.lesswrong.com/posts/hTwshHAce4qZHL5zE/propinquity-cities-so-far",
    "archived_snapshots": {
        "closest": {
            "status": "200",
            "available": true,
            "url": "http://web.archive.org/web/20210302115304/https://www.lesswrong.com/posts/hTwshHAce4qZHL5zE/propinquity-cities-so-far",
            "timestamp": "20210302115304"
        }
    }
 }
 */
//enum CodingKeys: CodingKey {
//case url
//    case archived_snapshots
//}

struct WaybackLinkFetcher {
    
    struct WBLSnapshot: Codable {
        struct Snap: Codable {
            let status: String
            let available: Bool
            let url: String
            let timestamp: String
        }
        let closest: Snap
    }

    struct WaybackLink: Codable {
        let url: String
        let archived_snapshots: WBLSnapshot
    }

    enum WaybackLinkFetcherError: Error {
        case UrlError, TransferFailure, DecodingFailure
    }
    
    func linkFor(urlString: String) async throws -> String {
        
        let archiveURLString = "https://archive.org/wayback/available?url=\(urlString)"
        
        guard let wbLookupLink = URL(string:archiveURLString) else {
            throw WaybackLinkFetcherError.UrlError
        }
        
        let request = URLRequest(url: wbLookupLink)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WaybackLinkFetcherError.TransferFailure
        }
        
        guard let decodedResponse = try? JSONDecoder().decode(WaybackLink.self, from: data) else {
            throw WaybackLinkFetcherError.DecodingFailure
        }
        
        return decodedResponse.archived_snapshots.closest.url
    }
}
