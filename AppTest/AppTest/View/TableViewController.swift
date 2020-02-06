//
//  TableViewController.swift
//  AppTest
//
//  Created by Jeferson Jesus on 06/02/20.
//  Copyright © 2020 Jeferson. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        return cell
    }


    
    private func getPosts() {
        PostService().getPosts(completion: { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts
            case .error(let error):
                self?.showAlertViewController(message: error.localizedDescription)
            }
        })
    }

   
    func showAlertViewController(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
