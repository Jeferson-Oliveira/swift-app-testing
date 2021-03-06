//
//  BaseService.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
import Alamofire


typealias JsonObject = [String : Any]

protocol BaseServiceProtocol {
    func request<T: Codable>(
            _ url: URL,
            method: HTTPMethod,
            parameters: [String: Any]?,
            headers: [String: String]?,
            encoding: ParameterEncoding,
            completion: @escaping (Result<T>) -> Void)
            -> Void

}

struct NoResult: Codable {}

enum Result<T : Decodable> {
    case success(T)
    case error(Error)
}


