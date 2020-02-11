//
//  AlamofireBaseService.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Alamofire

class AlamofireBaseService: BaseServiceProtocol {
    
    func encodeParam<T: Encodable>(_ object: T) -> Parameters? {
        return object.dictionary
    }
    
    func request<T: Encodable>(_ url: URL,
                 method: HTTPMethod,
                 parameters: [String : Any]? = nil,
                 headers: [String : String]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 completion: @escaping (Result<T>) -> Void) {
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: encoding,
                          headers: headers)
                 .responseJSON(completionHandler: { (response) in
                    if let error = response.error {
                      completion(.error(error))
                    } else if let resposeData = response.data {
                        do {
                            let value = try JSONDecoder().decode(T.self, from: resposeData)
                            completion(.success(value))
                        } catch {
                            completion(.error(error))
                        }
                  }
               })
    }
  
}
