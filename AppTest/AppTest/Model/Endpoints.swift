//
//  Endpoints.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

enum Endpoints {
    enum Posts: String {
        case list = "https://jsonplaceholder.typicode.com/posts"
        
        func url() -> String {
            return self.rawValue
        }
    }
}
