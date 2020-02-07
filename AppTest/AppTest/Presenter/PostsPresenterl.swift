//
//  PostsPresenter.swift
//  AppTest
//
//  Created by Jeferson Oliveira Cequeira de Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import Foundation

// MARK: Protocols
protocol PostPresenterProtocol {
    var inputs: PostsPresenterInput { get }
}

protocol PostsPresenterInput {
    func loadPosts()
    func addPost(_ post: Post)
    func deletePost(_ post: Post)
    func getPost(_ index: Int) -> Post?
    func getPostsCount() -> Int
}

protocol PostPresenterOutputDelegate: class {
    func startLoading()
    func endLoading()
    func postsDidChange(_ posts: [Post])
    func showFeedback(message: String)
}

// MARK: Presenter
class PostPresenter: PostPresenterProtocol {
    
    var inputs: PostsPresenterInput { self }
    var service: PostServiceProtocol
    weak var delegate: PostPresenterOutputDelegate?
    
    var posts = [Post]() {
        didSet {
            delegate?.postsDidChange(posts)
        }
    }
    
    init(service: PostServiceProtocol = PostService(), delegate: PostPresenterOutputDelegate? = nil) {
        self.service = service
        self.delegate = delegate
    }
}

// MARK: Inputs
extension PostPresenter: PostsPresenterInput {
    
    func loadPosts() {
        delegate?.startLoading()
        service.list { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .error(let error):
                self?.delegate?.showFeedback(message: error.localizedDescription)
            }
            self?.delegate?.endLoading()
        }
    }
    
    func addPost(_ post: Post) {
        delegate?.startLoading()
        service.add(post) { [weak self] result in
            switch result {
            case .success(let newPost):
                self?.posts.append(newPost)
            case .error(let error):
                self?.delegate?.showFeedback(message: error.localizedDescription)
            }
            self?.delegate?.endLoading()
        }
    }
    
    func deletePost(_ post: Post) {
        delegate?.startLoading()
        service.delete(post) { [weak self] result in
            switch result {
            case .success:
                self?.posts.removeAll(where: { $0.id == post.id})
            case .error(let error):
                self?.delegate?.showFeedback(message: error.localizedDescription)
            }
            self?.delegate?.endLoading()
        }
    }
    
    func getPost(_ index: Int) -> Post? {
        return index < posts.count ? posts[index] : nil
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
}
