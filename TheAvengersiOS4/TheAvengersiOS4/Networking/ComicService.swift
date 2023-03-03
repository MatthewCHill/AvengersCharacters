//
//  ComicService.swift
//  TheAvengersiOS4
//
//  Created by Matthew Hill on 3/2/23.
//

import UIKit

struct ComicService {
    
    static func fetchComicList(paginationOffset offset: String, forCharacter character: Character, completion: @escaping(Result<ComicTopLevelDict, NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: Constants.AvengersURL.baseURL) else { completion(.failure(.invalidURL)); return}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path.append(contentsOf: "/\(character.characterID)")
        urlComponents?.path.append(contentsOf: Constants.AvengersURL.comicPath)
        
        let limitQuery = URLQueryItem(name: Constants.UrlQueryComponents.limitQueryKey, value: Constants.UrlQueryComponents.comicLimitQueryValue)
        let timestampQuery = URLQueryItem(name: Constants.UrlQueryComponents.timeStampQueryKey, value: Constants.UrlQueryComponents.timeStampQueryValue)
        let offsetQuery = URLQueryItem(name: Constants.UrlQueryComponents.offsetQueryKey, value: offset)
        let apiKeyQuery = URLQueryItem(name: Constants.UrlQueryComponents.apiKeyKey, value: Constants.UrlQueryComponents.apiKeyValue)
        let hashQuery = URLQueryItem(name: Constants.UrlQueryComponents.hashQueryKey, value: Constants.UrlQueryComponents.hashQueryValue)
        urlComponents?.queryItems = [limitQuery, offsetQuery, timestampQuery, apiKeyQuery, hashQuery]
        
        guard let finalURL = urlComponents?.url else {completion(.failure(.invalidURL)); return}
        print("Comic List final URL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            
            guard let data = data else {completion(.failure(.noData)); return}
            
            do {
                let topLevel = try JSONDecoder().decode(ComicTopLevelDict.self, from: data)
                completion(.success(topLevel))
            } catch {
                completion(.failure(.unableToDecode))
                print("from fetchComicList data.")
                return
            }
        }.resume()
    }
    
    static func fetchComicImage(forComic comic: Comic, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
        guard let finalURL = URL(string: "\(comic.thumbnail.imagePath).\(comic.thumbnail.imageExtension)") else {completion(.failure(.invalidURL)); return}
        print("Comic Image Url:\(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            guard let data = data else { completion(.failure(.noData)); return}
            guard let image = UIImage(data: data) else {completion(.failure(.noData)); return}
            completion(.success(image))
        }.resume()
    }
}
