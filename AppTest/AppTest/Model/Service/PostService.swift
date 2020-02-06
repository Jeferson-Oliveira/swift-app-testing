//
//  PostService.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

protocol PostServiceProtocol {
    func getPosts(completion: @escaping (Result<[Post]>) -> Void)
}

class PostService: AlamofireBaseService {
    
}

extension PostService: PostServiceProtocol {
    func getPosts(completion: @escaping (Result<[Post]>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        request(url, method: .get, completion: completion)
    }
}
