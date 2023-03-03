//
//  Comic.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/2/23.
//

import Foundation

struct ComicTopLevelDict: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case topLevelDict = "data"
    }
    
    let topLevelDict: DataDict
}

struct DataDict: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case offset
        case count
        case comics = "results"
    }
    let offset: Int
    let count: Int
    let comics: [Comic]
}

struct Comic: Decodable {
    let title: String
    let thumbnail: ComicImage
}

struct ComicImage: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case imagePath = "path"
        case imageExtension = "extension"
    }
    
    let imagePath: String
    let imageExtension: String
}
