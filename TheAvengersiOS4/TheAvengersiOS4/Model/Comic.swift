//
//  Comic.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/2/23.
//

import Foundation

struct ComicTopLevelDict: Decodable {
    let data: DataDict
}

struct DataDict: Decodable {
    let resutls: [Comic]
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
