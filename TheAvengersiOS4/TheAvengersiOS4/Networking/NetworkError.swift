//
//  NetworkError.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

enum NetworkError: LocalizedError {
case invalidURL
case thrownError(Error)
case noData
case unableToDecode
case emptyArray
    
    var errorDescription: String? {
        switch self {
            
        case .invalidURL:
            return "Invalid URL. Check URL endpoint."
        case .thrownError(let error):
            return "Thrown error. Error was \(error.localizedDescription)"
        case .noData:
            return "No data received from the network fetch."
        case .unableToDecode:
            return "Unable to decode model object from data."
        case .emptyArray:
            return " Recipe returned an empty array."
        }
    }
}
