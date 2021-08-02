//
//  RequestEndPoint.swift
//  Shopper
//
//  Created by Avinash on 28/07/21.
//  Copyright © 2021 Avinash. All rights reserved.
//

import Foundation

enum RequestEndPoint {
    case getProducts
    
    public var scheme: String {
        return "https"
    }
    
    public var method: String {
        switch self {
        case .getProducts:
            return "GET"
        }
    }
    
    public var host: String {
        return "60d2fa72858b410017b2ea05.mockapi.io"
    }
    
    public var path: String? {
        switch self {
        case .getProducts:
            return "/api/v1/menu"
        }
    }
    
    /// Adding queries for UrlRequest
    public var parameters: [URLQueryItem] {
        switch self {
        case .getProducts:
            var query = [URLQueryItem]()
            return query
        }
    }
}
