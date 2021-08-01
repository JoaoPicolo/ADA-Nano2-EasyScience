//
//  QuizzViewController.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 29/07/21.
//

import UIKit

struct Answer {
    let text: String
    let corret: Bool
}


struct Question {
    let text: String
    let answers: [Answer]
}

class QuizzViewController: UIViewController {
    var quizzModels = [Question]()
    
    var currentQuestion: Question?
    var answeredCorrectly: Bool?
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
        answeredCorrectly = nil
        selectedAnswer = -1
        
        answersTable.reloadData()
    }
    
    @objc private func verifyAnswer() {
        let answer = currentQuestion!.answers[selectedAnswer]
        answeredCorrectly = currentQuestion?.answers.contains(where: { $0.text == answer.text }) ?? false && answer.corret
        answersTable.reloadData()
    }
    
    @objc private func nextQuestion() {
        guard let question = currentQuestion else {
            return
        }

        if let index = quizzModels.firstIndex(where: { $0.text == question.text }) {
            if index < quizzModels.count - 1 {
                let nextQuestion = quizzModels[index + 1]
                currentQuestion = nil
                configureUI(question: nextQuestion)
            }
            else {
                let alert = UIAlertController(title: "Done", message: "Good job!", preferredStyle: .alert)
                alert.addAction((UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)))
                present(alert, animated: true)
            }
        }
    }
    
    private func checkAnswer(answer: Answer, question: Question) -> Bool {
        return  question.answers.contains(where: { $0.text == answer.text }) && answer.corret
    }
    
    private func setUpQuestions() {
        quizzModels.append(Question(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue. Quisque in nisi pellentesque, dignissim magna et, luctus quam. Aliquam erat volutpat. Morbi rutrum ante quis felis vehicula volutpat ut et justo.", answers: [Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: true), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false)]))
        
        quizzModels.append(Question(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam suscipit sem ut quam molestie congue.", answers: [Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: false), Answer(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", corret: true)]))
        
    }

}

extension QuizzViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureButtonConstraints(_ button: UIButton, _ footer: UIView) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: footer.topAnchor, constant: 30),
            button.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: 0),
            button.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 30),
            button.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -30),
        ])
    }
    
    private func setUpNextButton(_ footer: UIView) {
        let nextButton = UIButton()
        nextButton.layer.cornerRadius = 10.0
        nextButton.center = footer.center
        nextButton.setTitle("Next", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextQuestion), for: .touchUpInside)
        nextButton.setTitleColor(UIColor(named: "projectWhite"), for: .normal)
        nextButton.backgroundColor = answeredCorrectly! ? UIColor(named: "projectGreen") : UIColor(named: "projectRed")
        
        footer.addSubview(nextButton)
        configureButtonConstraints(nextButton, footer)
    }
    
    private func setUpVerifyButton(_ footer: UIView) {
        let hasChosenAnswer = selectedAnswer != -1
        
        let verifyButton = UIButton()
        verifyButton.layer.cornerRadius = 10.0
        verifyButton.center = footer.center
        verifyButton.isEnabled = hasChosenAnswer
        verifyButton.setTitle("Verify", for: .normal)
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.addTarget(self, action: #selector(verifyAnswer), for: .touchUpInside)
        verifyButton.setTitleColor(UIColor(named: "projectWhite"), for: .normal)
        verifyButton.backgroundColor = hasChosenAnswer ? UIColor(named: "projectBlue") : UIColor(named: "projectGray")
        
        footer.addSubview(verifyButton)
        configureButtonConstraints(verifyButton, footer)
    }
    
    private func setUpTabeCell(_ cell: UITableViewCell) {
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.systemGray
        
        cell.contentView.layer.borderWidth = 0.4
        cell.contentView.layer.borderColor = UIColor(named: "projectWhite")!.cgColor
        cell.contentView.layer.cornerRadius = 5
        cell.selectedBackgroundView = selectedView
    }
    
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
        if answeredCorrectly != nil { // Has verified one answer
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
            let answer = currentQuestion!.answers[indexPath.section]
            
            if(answer.corret) {
                if(selectedAnswer == indexPath.section) {
                    cell.configure(with: answer.text, markerName: "checkmark.circle.fill")
                }
                else {
                    cell.configure(with: answer.text, markerName: "checkmark.circle.fill")
                }
            }
            else {
                if(selectedAnswer == indexPath.section) {
                    cell.configure(with: answer.text, markerName: "xmark.circle.fill")
                }
                else {
                    cell.configure(with: answer.text, markerName: "xmark.circle.fill")
                }
            }
            
            setUpTabeCell(cell)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
            if(selectedAnswer != indexPath.section) { // Verifies if row changed
                cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge")
            }
            else {
                cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge.fill")
            }
            
            setUpTabeCell(cell)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedAnswer == -1 { // If not choosen, reloads whole table on first (because of footer)
            selectedAnswer = indexPath.section
            answersTable.reloadData()
        }
        else {
            if answeredCorrectly == nil { // Changes only when no other cell has been marked as answer
                let oldSelected = selectedAnswer
                selectedAnswer = indexPath.section
                answersTable.reloadSections([indexPath.section, oldSelected], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let total = currentQuestion?.answers.count ?? 0
        var height = CGFloat(0)

        if (section == total - 1){
            height = CGFloat(80)
        }

        return height
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let total = currentQuestion?.answers.count ?? 0
        guard section == total - 1 else { return nil }

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: answersTable.frame.width, height: 44.0))
        
        if answeredCorrectly != nil {
            setUpNextButton(footerView)
        }
        else {
            setUpVerifyButton(footerView)
        }

        return footerView
    }
}
