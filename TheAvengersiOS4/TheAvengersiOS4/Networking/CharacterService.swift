//
//  CharacterService.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/1/23.
//

import UIKit

struct CharacterService {
    
    
    
    static func fetchCharacterList(paginationOffset offset: String, completion: @escaping (Result<CharacterListTopLevelDictionary, NetworkError>) -> Void) {
        
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
        print("Character List final URL: \(finalURL)")
        
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
                let topLevel = try JSONDecoder().decode(CharacterListTopLevelDictionary.self, from: data)
                completion(.success(topLevel))
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    
    }
    
    static func fetchCharacterImage(for character: Character, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let finalURL = URL(string: "\(character.characterImage.path).\(character.characterImage.imageExtension)") else {completion(.failure(.invalidURL)); return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            guard let data = data else {completion(.failure(.noData)); return}
            guard let image = UIImage(data: data) else {completion(.failure(.unableToDecode)); return}
            completion(.success(image))
            
        }.resume()
    }
    
    static func fetchCharacter(forCharacter: Character, completion: @escaping (Result<Character, NetworkError>) -> Void) {
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(contentsOf: "/\(forCharacter.characterID)")
        
        let timestampQuery = URLQueryItem(name: Constants.UrlQueryComponents.timeStampQueryKey, value: Constants.UrlQueryComponents.timeStampQueryValue)
        let apiKeyQuery = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery = URLQueryItem(name: Constants.UrlQueryComponents.hashQueryKey, value: Constants.UrlQueryComponents.hashQueryValue)
        urlComponents?.queryItems = [timestampQuery, apiKeyQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL)); return}
        print("Character List final URL: \(finalURL)")
        
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
                let topLevel = try JSONDecoder().decode(CharacterListTopLevelDictionary.self, from: data)
                if let character = topLevel.data.results.first {
                    completion(.success(character))
                } else {
                    completion(.failure(.unableToDecode))
                }
            } catch {
                completion(.failure(.unableToDecode))
                return
            }
        }.resume()
    }
    
}
