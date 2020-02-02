//
//  StartPageViewController.swift
//  FlappyBird
//
//  Created by Sushant Lenka  on 02/02/20.
//  Copyright © 2020 Fullstack.io. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController {
    @IBOutlet weak var startGameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func changeScreen(_ sender: UIButton) {
        performSegue(withIdentifier: "viewChange", sender: self)
    }
    
    
}
