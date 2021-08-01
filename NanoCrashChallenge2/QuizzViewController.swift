//
//  QuizzViewController.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 29/07/21.
//

import UIKit

class QuizzViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var quizzModels = [Question]()
    
    var currentQuestion: Question?
    var selectedAnswer = -1
    var navigationTitle = ""
    
    @IBOutlet var label: UILabel!
    @IBOutlet var answersTable: UITableView!
    @IBOutlet var quizzNavigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        answersTable.register(AnswerTableViewCell.nib(), forCellReuseIdentifier: AnswerTableViewCell.identifier)
        answersTable.delegate = self
        answersTable.dataSource = self

        setUpQuestions()
        
        quizzNavigationItem.title = navigationTitle
        configureUI(question: quizzModels.first!)
    }
    
    private func configureUI(question: Question) {
        label.text = question.text
        currentQuestion = question
        
        answersTable.reloadData()
    }
    
    private func checkAnswer(answer: Answer, question: Question) -> Bool {
        return  question.answers.contains(where: { $0.text == answer.text }) && answer.corret
    }
    
    private func setUpQuestions() {
        quizzModels.append(Question(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue. Quisque in nisi pellentesque, dignissim magna et, luctus quam. Aliquam erat volutpat. Morbi rutrum ante quis felis vehicula volutpat ut et justo.", answers: [Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue.", corret: true), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue.", corret: false)]))
        
    }
    
    // Table View Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return currentQuestion?.answers.count ?? 0
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
        let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
        
        if(selectedAnswer != indexPath.section) {
            cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge")
        }
        else {
            cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge.fill")
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.systemGray
        
        // Adds border to cell
        cell.contentView.layer.borderWidth = 0.4
        cell.contentView.layer.borderColor = UIColor(named: "projectWhite")!.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.selectedBackgroundView = selectedView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswer = indexPath.section
        answersTable.reloadData()
        
//        guard let question = currentQuestion else {
//            return
//        }
//        let answer = question.answers[indexPath.row]
//        
//        if checkAnswer(answer: answer, question: question) {
//            if let index = quizzModels.firstIndex(where: { $0.text == question.text }) {
//                if index < quizzModels.count - 1 {
//                    let nextQuestion = quizzModels[index + 1]
//                    currentQuestion = nil
//                    configureUI(question: nextQuestion)
//                }
//                else {
//                    let alert = UIAlertController(title: "Done", message: "Good job!", preferredStyle: .alert)
//                    alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
//                    present(alert, animated: true)
//                }
//            }
//            
//        }
//        else {
//            let alert = UIAlertController(title: "Wrong", message: "Try again", preferredStyle: .alert)
//            alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
//            present(alert, animated: true)
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let hasChosenAnswer = selectedAnswer != -1
        let total = currentQuestion?.answers.count ?? 0
        var height = CGFloat(0)

        if (section == total - 1) && hasChosenAnswer {
            height = CGFloat(80)
        }

        return height
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let hasChosenAnswer = selectedAnswer != -1
        
        let total = currentQuestion?.answers.count ?? 0
        guard section == total - 1 else { return nil }

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: answersTable.frame.width, height: 44.0))
        
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 280, height: 58))
        doneButton.center = footerView.center
        doneButton.setTitle("Verify", for: .normal)
        doneButton.isEnabled = hasChosenAnswer
        doneButton.backgroundColor = UIColor(named: "projectBlue")
        doneButton.layer.cornerRadius = 10.0
        
        footerView.addSubview(doneButton)

        return footerView
    }
}

struct Question {
    let text: String
    let answers: [Answer]
}

struct Answer {
    let text: String
    let corret: Bool
}
