//
//  MovieDBService.swift
//  MovieDB
//
//  Created by Chris Mitchelmore on 27/07/2017.
//  Copyright © 2017 Marks and Spencer. All rights reserved.
//

import UIKit

protocol Cancelable {
  func cancel()
}

extension URLSessionDataTask: Cancelable {}

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

protocol MovieDBService {
	func loadImagePath(_ path: String, completion: @escaping (UIImage) -> Void) -> Cancelable?
  func getMovies(_ completion: @escaping (Result<NowPlaying>) -> Void)
  func getMovie(id: String, completion: @escaping (Result<Movie>) -> Void)
  func getCollection(id: String, completion: @escaping (Result<MovieCollection>) -> Void)
}

class MovieDBServiceImplementation: MovieDBService {

  static var shared: MovieDBService = MovieDBServiceImplementation(apiKey: "9062e9e1c7fc6393168d864413575b83")

  private lazy var releaseDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-mm-dd"
    return dateFormatter
  }()
  private let session = URLSession(configuration: URLSessionConfiguration.default)
  private let host = "http://api.themoviedb.org"
  private let apiVersion = "3"
  private let imageHost = "http://image.tmdb.org/t/p/w185"
  private let nowPlayingPath = "/movie/now_playing"
  private let region = "GB"
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
    components.path = "/\(apiVersion)\(path)"
    components.queryItems = [URLQueryItem(name: "api_key", value: apiKey), URLQueryItem(name: "region", value: region)]
    return URLRequest(url: components.url!)
  }

  private func performRequest<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T>) -> Void) {
    session.dataTask(with: request) { (data, response, error) in
      if let error = error {
        DispatchQueue.main.async { completion(.error(ServiceError.httpError(error))) }
      }

      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode / 100 != 2 {
        DispatchQueue.main.async { completion(.error(ServiceError.requestFailedWithStatusCode(httpResponse.statusCode))) }
      }

      guard let data = data else {
        DispatchQueue.main.async { completion(.error(ServiceError.noData)) }
        return
      }

      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(self.releaseDateFormatter)
      do {
        let returnValue = try decoder.decode(T.self, from: data)
        print(returnValue)
        DispatchQueue.main.async { completion(.success(returnValue)) }
      } catch {
        DispatchQueue.main.async { completion(.error(ServiceError.parsingError(error))) }
      }
    }.resume()
  }

  func loadImagePath(_ path: String, completion: @escaping (UIImage) -> Void) -> Cancelable? {

    if let url = URL(string: imageHost + path) {
      let task = session.dataTask(with: url) { data, _, _ in
        if let data = data, let image = UIImage(data: data) {
          completion(image)
        }
      }
      task.resume()
      return task
    }

    return nil
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
