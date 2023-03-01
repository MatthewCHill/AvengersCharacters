//
//  CharacterService.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import Foundation

struct CharacterService {
    
    
    
    static func fetchCharacterList(paginationOffset offset: String, completion: @escaping (Result<[Character], NetworkError>) -> Void) {
        
        // https://gateway.marvel.com/v1/public/characters?limit=100&offset=0&ts=1&apikey=38de6355e5781d4a94a83902450e9fb2&hash=378bcd62387cf556feaa87207925b702
        
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let limitQuery = URLQueryItem(name: Constants.UrlQueryComponents.limitQueryKey, value: Constants.UrlQueryComponents.limitQueryValue)
        let offsetQuery = URLQueryItem(name: Constants.UrlQueryComponents.offsetQueryKey, value: offset)
        let timestampQuery = URLQueryItem(name: Constants.UrlQueryComponents.timeStampQueryKey, value: Constants.UrlQueryComponents.timeStampQueryValue)
        let apiKeyQuery = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery = URLQueryItem(name: Constants.UrlQueryComponents.hashQueryKey, value: Constants.UrlQueryComponents.hashQueryValue)
        urlComponents?.queryItems = [limitQuery, offsetQuery, timestampQuery, apiKeyQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL)); return}
        print("Avengers List final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)); return}
            
            do {
                let topLevel = try JSONDecoder().decode(CharacterTopLevelDictionary.self, from: data)
                completion(.success(topLevel.data.results))
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    
    }
    
}
