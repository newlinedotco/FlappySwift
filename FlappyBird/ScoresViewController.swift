//
//  ScoresViewController.swift
//  FlappyBird
//
//  Created by Dubal, Rohan on 10/27/18.
//  Copyright © 2018 Fullstack.io. All rights reserved.
//

import Foundation
import UIKit

class ScoresViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoresTableView: UITableView!
    let cellReuseIdentifier = "cell"
    
    var scores: [String] = [] {
        didSet {
            self.scoresTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        self.scoresTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
}

extension ScoresViewController: UITableViewDelegate {
    
}

extension ScoresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.scoresTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        // set the text from the data model
        cell.textLabel?.text = "\(indexPath.row+1) \t \(self.scores[indexPath.row])"
        return cell

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }

}
