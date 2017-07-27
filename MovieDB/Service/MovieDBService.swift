//
//  MovieDBService.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

enum Result<T> {
  case success(T)
  case error(Error)
}

enum ServiceError: Error {
  case httpError(Error)
  case requestFailedWithStatusCode(Int)
  case noData
  case parsingError(Error)
}

class MovieDBService {
  
  static let shared = MovieDBService(apiKey: "9062e9e1c7fc6393168d864413575b83"))
  
  private let session = URLSession(configuration: URLSessionConfiguration.default)
  private let host = "http://api.themoviedb.org/3/"
  private let imageHost = "http://image.tmdb.org/t/p/w185"
  private let nowPlayingPath = "/movie/now_playing"
  private func collectionPath(id: String) -> String {
    return "/collection/\(id)"
  }
  private func moviePath(id: String) -> String {
    return "/movie/\(id)"
  }
  let apiKey: String
  
  private init(apiKey: String) {
    self.apiKey = apiKey
  }
  
  private func requestForPath(_ path: String) -> URLRequest {
    var components = URLComponents(string: host)!
    components.path = path
    components.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
    return URLRequest(url: components.url!)
  }
  
  private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T>) -> Void) {
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.error(ServiceError.httpError(error)))
      }
      
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode / 100 != 2 {
        completion(.error(ServiceError.requestFailedWithStatusCode(httpResponse.statusCode)))
      }
      
      guard let data = data else {
        return completion(.error(ServiceError.noData))
      }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      do {
        let collection = try decoder.decode(T.self, from: data)
        completion(.success(collection))
      } catch {
        completion(.error(ServiceError.parsingError(error)))
      }
    }
  }
  
  func loadImagePath(_ path: String, completion: @escaping (UIImage) -> Void) {
    if let url = URL(string: imageHost + path) {
      session.dataTask(with: url) { data, _, _ in
        if let data = data, let image = UIImage(data: data) {
          completion(image)
        }
      }
    }
  }
  
  func getMovies(_ completion: @escaping (Result<NowPlaying>) -> Void)  {
    let request = requestForPath(nowPlayingPath)
    performRequest(request, completion: completion)
  }
  
  func getMovie(id: String, completion: @escaping (Result<Movie>) -> Void)  {
    let request = requestForPath(moviePath(id: id))
    performRequest(request, completion: completion)
  }
  
  func getCollection(id: String, completion: @escaping (Result<MovieCollection>) -> Void)  {
    let request = requestForPath(collectionPath(id: id))
    performRequest(request, completion: completion)
  }
}
