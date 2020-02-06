//
//  PostTest.swift
//  AppTestTests
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Quick
import Nimble
import Mockingjay

@testable import AppTest

class PostServiceTest: QuickSpec {
    override func spec() {
        
        
        let error = NSError.init(domain: "test", code: 1, userInfo: nil)
        
        describe("Post Service Test") {
            var service: PostServiceProtocol!
            
            beforeEach {
                service = PostService()
            }
            
            context("List Posts") {
                
                it("Should return the list of posts") {
                    
                    // Given
                    var response: [Post]?
                    let object = [
                                 "id": 1,
                                 "title" : "Teste",
                                 "body": "Teste Body" ] as [String : Any]
                    
                    self.stub(http(.get, uri: Endpoints.Posts.list.url()), json([object, object]))
                    service.getPosts(completion: { result in
                        switch result {
                        case .success(let posts):
                            response = posts
                        case .error(let error):
                            fail(error.localizedDescription)
                        }
                    })
                    expect(response).toEventuallyNot(beNil())
                }
                
                it("Should return error") {
                    // Given
                    self.stub(http(.get, uri: Endpoints.Posts.list.url()), failure(error))
                    var response: Error?
                    
                    // When
                    service.getPosts(completion: { result in
                        switch result {
                        case .success:
                            fail("Error not returned")
                        case .error(let error):
                            response = error
                        }
                    })
                    
                    // Then
                    expect(response).toEventuallyNot(beNil())
                }
                
                it("Should return a parse error") {
        
                    // Given
                    let object = ["invalidKey" : "invalidValue" ] as [String : Any]
                    var response: Error?
                    self.stub(http(.get, uri: Endpoints.Posts.list.url()), json(object))
                    
                    // When
                    service.getPosts(completion: { result in
                        switch result {
                        case .success:
                            fail("Error not returned")
                        case .error(let error):
                            response = error
                        }
                    })
                    
                    // Then
                    expect(response).toEventuallyNot(beNil())
                }
            }
            
        }
    }
}
