//
//  RequestManager.swift
//  Shopper
//
//  Created by Avinash on 28/07/21.
//  Copyright © 2021 Avinash. All rights reserved.
//

import Foundation

typealias Response = Result<[ProductModel], SessionTaskError>

class RequestManager {
    static func fetchProducts(endPoint: RequestEndPoint, completion: @escaping (Response) -> Void) {
        /// URLRequest
        guard let request = RequestBuilder.buildURLRequest(endPoint: endPoint) else {
            completion(.failure(.requestError))
            return
        }
        /// Executing URLRequest
        RequestPerformer.request(urlRequest: request) { (result: Response) in
            completion(result)
        }
    }
}
