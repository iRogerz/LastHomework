//
//  Network.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

class Network {
    
    static func send(url: String,
                     parameters: [String: Any],
                     completion: @escaping (Result<Data, Error>) -> Void)
    {
        var components = URLComponents(string: url)
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        components?.queryItems = queryItems
        guard let url = components?.url else {
            completion(.failure(NetworkError.urlIsNil))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}

extension Network {
    
    enum NetworkError: Error, LocalizedError {
        case urlIsNil
        
        var errorDescription: String? {
            switch self {
            case .urlIsNil:
                return "url is nil"
            }
        }
    }
}

class CurrentDataService{
    private static let baseURL = "https://us-central1-redso-challenge.cloudfunctions.net/catalog"
    
    static func getCurrentData(by team:Catalog,
                               by page:Int,
                               completion: @escaping (Result<CurrentData, Error>) -> Void){
        var parameters: [String: Any] = [:]
        parameters["team"] = team.title
        parameters["page"] = page
        
        Network.send(url: baseURL, parameters: parameters) { result in
            switch result{
            case .success(let data):
                do{
                    let decoded = try JSONDecoder().decode(CurrentData.self, from: data)
                    completion(.success(decoded))
                }catch{
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum Catalog {
    case rengers, elastic, dynamo

    var title:String{
        switch self {
        case .rengers:
            return "rangers"
        case .elastic:
            return "elastic"
        case .dynamo:
            return "dynamo"
        }
    }
}
