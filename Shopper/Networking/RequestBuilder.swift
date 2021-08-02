//
//  RequestBuilder.swift
//  Shopper
//
//  Created by Avinash on 28/07/21.
//  Copyright © 2021 Avinash. All rights reserved.
//

import Foundation

/// Creating UrlRequest using Url components
class RequestBuilder {
    class func buildURLRequest(endPoint: RequestEndPoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = endPoint.scheme
        components.host = endPoint.host
        components.queryItems = endPoint.parameters
        if let path = endPoint.path { components.path = path }

        // URLRequest
        guard let url = components.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.method
        //urlRequest.setValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}
