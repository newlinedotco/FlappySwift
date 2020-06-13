//
//  StartingViewController.swift
//  FlappyBird
//
//  Created by Nato Egnatashvili on 6/13/20.
//  Copyright © 2020 Fullstack.io. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1
        startButton.backgroundColor = UIColor.green
        startButton.layer.borderColor = UIColor.green.cgColor
    }

    @IBAction func didTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as? GameViewController
            self.navigationController?.pushViewController(vc! , animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
