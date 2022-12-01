//
//  VideosModel.swift
//  testProject
//
//  Created by Sferea-Lider on 19/08/22.
//

import Foundation
import UIKit

struct VideoModel {
    var image: UIImage
    var id: String
}

// MARK: - PlayListModel
struct PlayListModel: Codable {
    let kind, etag, nextPageToken: String
    let items: [Item]
    let pageInfo: PageInfo
}

// MARK: - Item
struct Item: Codable {
    let kind, etag, id: String
    let snippet: Snippet
    let status: Status
}

// MARK: - Snippet
struct Snippet: Codable {
    let publishedAt: Date
    let channelID, title, snippetDescription: String
    let thumbnails: Thumbnails
    let channelTitle, playlistID: String
    let position: Int
    let resourceID: ResourceID
    let videoOwnerChannelTitle, videoOwnerChannelID: String

    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle
        case playlistID = "playlistId"
        case position
        case resourceID = "resourceId"
        case videoOwnerChannelTitle
        case videoOwnerChannelID = "videoOwnerChannelId"
    }
}

// MARK: - ResourceID
struct ResourceID: Codable {
    let kind, videoID: String

    enum CodingKeys: String, CodingKey {
        case kind
        case videoID = "videoId"
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    let thumbnailsDefault, medium, high, standard: Default
    let maxres: Default

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
}

// MARK: - Default
struct Default: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Status
struct Status: Codable {
    let privacyStatus: String
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults, resultsPerPage: Int
}
