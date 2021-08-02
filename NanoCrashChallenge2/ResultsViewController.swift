//
//  ResultsViewController.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 01/08/21.
//

import UIKit

class ResultsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Navigation Controller functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide navigation bar on this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on next view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

