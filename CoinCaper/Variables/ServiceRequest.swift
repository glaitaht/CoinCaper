//
//  PageRequest.swift
//  GameDB
//
//  Created by Cem Kılıç on 6.03.2022.
//
import Foundation

enum ServiceError: Error {
    case unconvertableURL
    case noDataAvailable
    case canNotProcessData
}

struct ServiceRequest {
    let urlSession = URLSession.shared

    func getPage<T: Decodable>(query: String, type: T, completion: @escaping (Result<T, ServiceError>) -> Void) {
        let resourceString = query
        guard let resourceURL = URL(string: resourceString) else {
            completion(.failure(.unconvertableURL))
            return
        }
        let request = URLRequest(url: resourceURL)

        self.urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.noDataAvailable))
                print("DataTask Error: \(error.localizedDescription)")
            }
            guard let data = data, response != nil else {
                print("Empty Data")
                return
            }
            do {
                let decoder = JSONDecoder()
                 
                let gameResult = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(gameResult))
                }
            } catch {
                completion(.failure(.canNotProcessData))
        }}.resume()
    }

}
