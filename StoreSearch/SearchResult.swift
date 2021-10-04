//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Josue Mendoza on 9/24/21.
//

import Foundation

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}
//This is the constant array for the text labels
private let typeForKind = [
  "album": NSLocalizedString(
    "Album",
    comment: "Localized kind: Album"),
  "audiobook": NSLocalizedString(
    "Audio Book",
    comment: "Localized kind: Audio Book"),
  "book": NSLocalizedString(
    "Book",
    comment: "Localized kind: Book"),
  "ebook": NSLocalizedString(
    "E-Book",
    comment: "Localized kind: E-Book"),
  "feature-movie": NSLocalizedString(
    "Movie",
    comment: "Localized kind: Feature Movie"),
  "music-video": NSLocalizedString(
    "Music Video",
    comment: "Localized kind: Music Video"),
  "podcast": NSLocalizedString(
    "Podcast",
    comment: "Localized kind: Podcast"),
  "software": NSLocalizedString(
    "App",
    comment: "Localized kind: Software"),
  "song": NSLocalizedString(
    "Song",
    comment: "Localized kind: Song"),
  "tv-episode": NSLocalizedString(
    "TV Episode",
    comment: "Localized kind: TV Episode")
]

//*/This class is to identify the items from the web search information*/
class SearchResult: Codable, CustomStringConvertible {
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    //*/This enum method is for the various variables that are read when the URL is found*/
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind , artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    //*/This variable is for the trackname*/
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    //*/This variable is for the track title*/
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    //*/This variable is for the price of the item*/
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    //*/This varibale is for the Genre information*/
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    //*/This variable is the list of items that will be gathered from the network*/
    var type: String {
        let kind = self.kind ?? "audiobook"
        return typeForKind[kind] ?? kind
    }
    //*/This variable reads the artist name*/
    var artist: String {
        return artistName ?? ""
    }
    //*/This variable reads the contents from the web and places them into the cell as a more readable form*/
    var description: String {
        return "\nResult - Kind: \(kind ?? "None"), Name: \(name), ArtistName: \(artistName ?? "None")"
    }
}

//*/This method is to sort the items alphabetically*/
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}
