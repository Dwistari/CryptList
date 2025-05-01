//
//  NetworkManager.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}

    func request<T: Decodable>(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
