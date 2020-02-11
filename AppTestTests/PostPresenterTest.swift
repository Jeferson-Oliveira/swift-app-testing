//
//  PostPresenterTest.swift
//  AppTestTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Quick
import Nimble
import Mockingjay
@testable import AppTest

class PostPresenterTest: QuickSpec {
    
    override func spec() {
        
        let presenterSpy = PostPresenterSpy()
        let error = NSError.init(domain: "test", code: 1, userInfo: nil)

        describe("Post Presenter") {
        
            beforeEach {
                presenterSpy.reset()
            }
            
            context("List Posts") {
                
                it("Should return the list of posts") {
                    
                    // Given
                    let object = [
                                 "id": 1,
                                 "title" : "Teste",
                                 "body": "Teste Body" ] as [String : Any]
                    
                    self.stub(http(.get, uri: Endpoints.Posts.list.url()), json([object, object]))
                    
                    // When
                    presenterSpy.loadPosts()
                    
                    // Then
                    expect(presenterSpy.didStartLoad).toEventually(beTrue())
                    expect(presenterSpy.didEndLoading).toEventually(beTrue())
                    expect(presenterSpy.loadedPosts).toEventuallyNot(beNil())
                                    
                }
                
                it("Should return an feedback message when error ocurrs") {
                    // Given
                    self.stub(http(.get, uri: Endpoints.Posts.list.url()), failure(error))
                    // When
                    presenterSpy.loadPosts()
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
            }
            
            context("Add Post") {
                it("Should return error message if post title is empty") {
                    // Given
                    let invalidPost = Post(id: .zero, title: "", body: "test")
                    // When
                    presenterSpy.addPost(invalidPost)
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
                
                it("Should return error message if post body is empty") {
                    // Given
                    let invalidPost = Post(id: .zero, title: "teste", body: "")
                    // When
                    presenterSpy.addPost(invalidPost)
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
                
                it("Should return a post if added with succesful") {
                    // Given
                    let newPost = Post(id: nil, title: "Test", body: "Test Body")
                                        
                    self.stub(http(.post, uri: Endpoints.Posts.add.url()), json(newPost.dictionary ?? [:]))
                    
                    // When
                    presenterSpy.addPost(newPost)
                    
                    // Then
                    expect(presenterSpy.didStartLoad).toEventually(beTrue())
                    expect(presenterSpy.didEndLoading).toEventually(beTrue())
                    expect(presenterSpy.loadedPosts).to(contain(newPost))
                }
                
                it("Should return an feedback message when error ocurrs") {
                    // Given
                    self.stub(http(.post, uri: Endpoints.Posts.add.url()), failure(error))
                    let newPost = Post(id: nil, title: "Test", body: "Test Body")
                    // When
                    presenterSpy.addPost(newPost)
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
            }
            
            context("Delete Post") {
                it("Should return error message if post id is invalid") {
                    // Given
                    let invalidPost = Post(id: .zero, title: "test", body: "test")
                    // When
                    presenterSpy.deletePost(invalidPost)
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
                
                
                it("Should remove the post if deleted with succesful") {
                    // Given
                    let post = Post(id: 1, title: "Test", body: "Test Body")
                    presenterSpy.loadedPosts = [post]
                    self.stub(http(.delete, uri: Endpoints.Posts.add.url()), json(NoResult().dictionary ?? [:]))
                    
                    // When
                    presenterSpy.deletePost(post)
                    
                    // Then
                    expect(presenterSpy.didStartLoad).toEventually(beTrue())
                    expect(presenterSpy.didEndLoading).toEventually(beTrue())
                    expect(presenterSpy.loadedPosts).toNot(contain(post))
                }
                
                it("Should return an feedback message when error ocurrs") {
                    // Given
                    let post = Post(id: 1, title: "Test", body: "Test Body")
                    self.stub(http(.delete, uri: Endpoints.Posts.delete(post.id ?? .zero).url()), failure(error))
                    // When
                    presenterSpy.deletePost(post)
                    // Then
                    expect(presenterSpy.feedbackMessage).toEventuallyNot(beNil())
                }
            }
            
        }
    }
}
