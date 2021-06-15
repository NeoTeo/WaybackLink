//
//  WaybackLinkFetcher.swift
//  WaybackLink
//
//  Created by teo on 15/06/2021.
//

import Foundation

struct WaybackLinkFetcher {
    enum WaybackLinkFetcherError: Error {
        case urlError
    }
    
    func linkFor(urlString: String) async throws -> URL {
        guard let wbLink = URL(string: "http://web.archive.org/web/20210302115304/https://www.lesswrong.com/posts/hTwshHAce4qZHL5zE/propinquity-cities-so-far") else {
            throw WaybackLinkFetcherError.urlError
        }
        return wbLink
    }
}
