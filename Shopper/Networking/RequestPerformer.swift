//
//  RequestPerformer.swift
//  Shopper
//
//  Created by Avinash on 28/07/21.
//  Copyright © 2021 Avinash. All rights reserved.
//

import Foundation

enum SessionTaskError: Error {
    /// Error for 'URLSession'.
    case connectionError
    
    /// Error for wrong Key.
    case authorizationError

    /// Error while creating 'URLReqeust'.
    case requestError

    /// Error while creating 'Response'.
    case responseError
    
    var errorMessage: String {
        switch self {
        case .connectionError:
            return "Operation Failed. Network Error. Try Later"
        case .requestError:
            return "Operation Failed. Improper Request"
        case .responseError:
            return "Operation Failed. Response is not in proper format"
        case .authorizationError:
            return "Authorization Failed. Please Check APIKey"
        }
    }
}

/// URLSession DataTask to execute URLRequest
class RequestPerformer {
    static var dataTask: URLSessionTask?
    
    static func request<M: Codable>(urlRequest: URLRequest, completion: @escaping (Result<M, SessionTaskError>) -> ()) {
        /// If Network call is inprogress then Canceling any on going call before making new call
        dataTask?.cancel()
        /// URLSession configuring
        let session = URLSession(configuration: .default)
        dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            switch (data, response, error) {
            case (_, _, let error?):
                if let error = error as? NSError {
                    switch error.code {
                    case -999:
                        print("Task Cancelled")
                    case -1009:
                        completion(.failure(.connectionError))
                    default:
                        completion(.failure(.responseError))
                    }
                    print(error.code)
                } else {
                    completion(.failure(.connectionError))
                }

            case (let data, _, _):
                do {
                    guard let responseData = data else {
                        completion(.failure(.responseError))
                        return
                    }
                    
                    /// Mapping Response Objects, by decoding JSON Data
                    let decoder = JSONDecoder()
                    let responseObject = try decoder.decode(M.self, from: responseData)
                    
                    DispatchQueue.main.async {
                        // CallBack Completion
                        completion(.success(responseObject))
                    }
                } catch {
                    print(error)
                    completion(.failure(.responseError))
                }
            }
        }
        dataTask?.resume()
    }
}
