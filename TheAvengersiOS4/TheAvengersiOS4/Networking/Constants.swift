//
//  Constants.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

struct Constants {
    
    // https://gateway.marvel.com/v1/public/characters?limit=100&offset=0&ts=1&apikey=38de6355e5781d4a94a83902450e9fb2&hash=378bcd62387cf556feaa87207925b702
    struct AvengersURL {
        
        static let baseURL = "https://gateway.marvel.com/v1/public/characters"
    }
    
    struct UrlQueryComponents {
        
        static let limitQueryKey = "limit"
        static let limitQueryValue = "20"
        
        static let offsetQueryKey = "offset"
        
        static let timeStampQueryKey = "ts"
        static let timeStampQueryValue = "1"
        
        static let apiKeyKey = "apikey"
        static let apiKeyValue = "38de6355e5781d4a94a83902450e9fb2"
        
        static let hashQueryKey = "hash"
        static let hashQueryValue = "378bcd62387cf556feaa87207925b702"
    }
}
