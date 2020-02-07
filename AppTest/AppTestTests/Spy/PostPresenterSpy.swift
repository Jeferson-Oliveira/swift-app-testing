//
//  PostPresenterSpy.swift
//  AppTestTests
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation
@testable import AppTest

class PostPresenterSpy: PostPresenter, PostPresenterOutputDelegate {
    
    var didStartLoad = false
    var didEndLoading = false
    var loadedPosts: [Post]?
    var feedbackMessage: String?
    
    init() {
        super.init()
        delegate = self
    }
    
    func reset() {
        didStartLoad = false
        didEndLoading = false
        loadedPosts = nil
        feedbackMessage = nil
    }
    
    func startLoading() {
        didStartLoad = true
    }
    
    func endLoading() {
        didEndLoading = true
    }
    
    func postsDidChange(_ posts: [Post]) {
        loadedPosts = posts
    }
    
    func showFeedback(message: String) {
        feedbackMessage = message
    }
}
