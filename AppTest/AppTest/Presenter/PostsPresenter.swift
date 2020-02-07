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
    private var service: PostServiceProtocol
    weak var delegate: PostPresenterOutputDelegate?
    
    private var posts = [Post]() {
        didSet {
            delegate?.postsDidChange(posts)
        }
    }
    
    init(service: PostServiceProtocol = PostService(), delegate: PostPresenterOutputDelegate? = nil) {
        self.service = service
        self.delegate = delegate
    }
    
    private func shouldAddPost(_ post: Post) -> Bool {
        if post.title == "" || post.body == "" {
            return false
        }
        return true
    }
    
    private func shouldDelete(_ post: Post) -> Bool {
        if post.id == .zero {
            return false
        }
        return true
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
        if shouldAddPost(post) {
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
        } else {
            delegate?.showFeedback(message: "Invalid Post")
        }
    }
    
    func deletePost(_ post: Post) {
        if shouldDelete(post) {
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
        } else {
            delegate?.showFeedback(message: "Invalid Post")
        }
    }
    
    func getPost(_ index: Int) -> Post? {
        return index < posts.count ? posts[index] : nil
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
}
