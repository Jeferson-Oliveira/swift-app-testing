//
//  TableViewController.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var presenter: PostPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PostPresenter(delegate: self)
        presenter.inputs.loadPosts()
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(TableViewController.refreshControlAction), for: .valueChanged)
    }
    
    @objc func refreshControlAction() {
        presenter.inputs.loadPosts()
    }
    
     func showAlertViewController(message: String) {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
         let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
         alert.addAction(action)
         present(alert, animated: true, completion: nil)
     }
    
}

// MARK: TableView Delegates
extension TableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.inputs.getPostsCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = presenter.inputs.getPost(indexPath.row) else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let post = presenter.inputs.getPost(indexPath.row) else {return}
            presenter.inputs.deletePost(post)
        }
    }
}

// MARK: ViewModel Outputs
extension TableViewController: PostPresenterOutputDelegate {
    func startLoading() {
        refreshControl?.beginRefreshing()
    }
    
    func endLoading() {
        refreshControl?.endRefreshing()
    }
    
    func postsDidChange(_ posts: [Post]) {
        tableView.reloadData()
    }
    
    func showFeedback(message: String) {
        showAlertViewController(message: message)
    }
}
