//
//  PostService.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import Alamofire

protocol PostServiceProtocol {
    func list(completion: @escaping (Result<[Post]>) -> Void)
    func add(_ post: Post, completion: @escaping (Result<Post>) -> Void)
    func update(_ post: Post, completion: @escaping (Result<Post>) -> Void)
    func delete(_ post: Post, completion: @escaping (Result<NoResult>) -> Void)
}

class PostService: AlamofireBaseService {

}

extension PostService: PostServiceProtocol {
  
    func list(completion: @escaping (Result<[Post]>) -> Void) {
        guard let url = URL(string: Endpoints.Posts.list.url()) else { return }
        request(url,
                method: .get,
                completion: completion)
    }
    
    func add(_ post: Post, completion: @escaping (Result<Post>) -> Void) {
        guard
            let url = URL(string: Endpoints.Posts.add.url()),
            let params = encodeParam(post) else { return }
        request(url,
                method: .post,
                parameters: params,
                encoding: JSONEncoding.default,
                completion: completion)
    }
    
    func update(_ post: Post, completion: @escaping (Result<Post>) -> Void) {
        guard
            let url = URL(string: Endpoints.Posts.update(post.id ?? .zero).url()),
            let params = encodeParam(post) else { return }
        request(url,
                method: .put,
                parameters: params,
                encoding: JSONEncoding.default,
                completion: completion)
    
    }
    
    func delete(_ post: Post, completion: @escaping (Result<NoResult>) -> Void) {
        guard
            let url = URL(string: Endpoints.Posts.delete(post.id ?? .zero).url()) else { return }
        request(url,
                method: .delete,
                completion: completion)
    }

}



