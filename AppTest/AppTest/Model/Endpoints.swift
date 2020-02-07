//
//  Endpoints.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

struct API {
    static let baseUrl = "https://jsonplaceholder.typicode.com/posts"
}

enum Endpoints {
    enum Posts {
        
        case list
        case add
        case update(Int)
        case delete(Int)
        
        func url() -> String {
            switch self {
            case .add:
                return API.baseUrl
            case .list:
                return API.baseUrl
            case .update(let id):
                return "\(API.baseUrl)/\(id)"
            case .delete(let id):
                return "\(API.baseUrl)/\(id)"
            }
        }
    }
}
