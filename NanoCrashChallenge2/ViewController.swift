//
//  ViewController.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 29/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startQuizz() {
        let vc = storyboard?.instantiateViewController(identifier: "quizz") as! QuizzViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}


