//
//  ViewController.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 29/07/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var categories = [Category]()
    
    @IBOutlet var inspirationText: UILabel!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var table: UITableView!
    
    @IBAction func startQuizz() {
        let vc = storyboard?.instantiateViewController(identifier: "quizz") as! QuizzViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.register(CategoryTableViewCell.nib(), forCellReuseIdentifier: CategoryTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        setUpCategories()
        
        inspirationText.text = "\"If you can’t explain something in simple terms, you don't understand it.\""
        
        profileName.text = "Jonas Kahnwald"
        profilePicture.image = UIImage(named: "profilePicture")
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
        
    }
    
    private func setUpCategories() {
        categories.append(Category(name: "All fields", description: "Test your general knowledge about all fields of science", iconName: "books"))
        categories.append(Category(name: "Astronomy", description: "Check out 7 questions about the wonders of our universe", iconName: "telescope"))
        categories.append(Category(name: "Chemistry", description: "Check out 7 questions about the science of matter", iconName: "chemistry"))
    }
    
    // Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as! CategoryTableViewCell
        cell.configure(category: categories[indexPath.section].name, description: categories[indexPath.section].description, iconName: categories[indexPath.section].iconName)
        
        
        // Adds border to cell
        cell.contentView.layer.borderWidth = 0.4
        cell.contentView.layer.borderColor = UIColor(named: "projectPurple")!.cgColor
        cell.contentView.layer.cornerRadius = 5

        return cell
    }
}

struct Category {
    let name: String
    let description: String
    let iconName: String
}

