//
//  CharactersList.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

struct CharacterListTopLevelDictionary: Decodable {
    
    let data: Results
}

struct Results: Decodable {
    let offset: Int
    let results: [Character]
}

struct Character: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case characterID = "id"
        case characterName = "name"
        case characterImage = "thumbnail"
        case comicsAppearingIn = "comics"
        case collectionURI
    }
    let characterID: Int
    let characterName: String
    let characterImage: Thumbnail
    let comicsAppearingIn: Comics
    let collectionURI: String
    
}

struct Thumbnail: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
    
    let path: String
    let imageExtension: String
}

struct Comics: Decodable {
    let available: Int
    let collectionURI: String
}
