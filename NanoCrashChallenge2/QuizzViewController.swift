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
    let id: Int
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
    @IBOutlet var questionsBar: UIView!
    
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
        
        let total = quizzModels.count
        questionsBar.layer.sublayers = nil
        for i in 1...total {
            if(i != currentQuestion?.id ?? 1) {
                let circle = UIView(frame: CGRect(x: (i * 60), y: 28, width: 40, height: 40))
                circle.backgroundColor = UIColor(named: "projectMediumPurple")
                circle.layer.cornerRadius = 20
                
                let label = UILabel(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
                label.text = String(i)
                label.textColor = UIColor(named: "projectWhite")
                
                circle.addSubview(label)
                questionsBar.addSubview(circle)
            }
            else {
                let circle = UIView(frame: CGRect(x: (i * 60), y: 25, width: 44, height: 44))
                let gradient = CAGradientLayer()
                gradient.colors = [UIColor(named: "projectGradientStart")!.cgColor, UIColor(named: "projectGradientEnd")!.cgColor]
                gradient.endPoint = CGPoint(x: 0.6, y: 0.5)
                gradient.frame = circle.bounds
                circle.layer.addSublayer(gradient)
                circle.layer.cornerRadius = 22
                gradient.cornerRadius = 22
                
                let label = UILabel(frame: CGRect(x: 17, y: 12, width: 20, height: 20))
                label.text = String(i)
                label.textColor = UIColor(named: "projectWhite")
                
                circle.addSubview(label)
                questionsBar.addSubview(circle)
            }
            
        }
        
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
                performSegue(withIdentifier: "endQuizz", sender: self)
            }
        }
    }
    
    private func checkAnswer(answer: Answer, question: Question) -> Bool {
        return  question.answers.contains(where: { $0.text == answer.text }) && answer.corret
    }
    
    private func setUpQuestions() {
        quizzModels.append(Question(id: 1, text: "Why do stars have different colors?", answers: [Answer(text: "The color changes according to the temperature", corret: true), Answer(text: "Stars don't have colors", corret: false), Answer(text: "All stars have the same color", corret: false), Answer(text: "The color changes according to its chemical components", corret: false)]))
        
        quizzModels.append(Question(id: 2, text: "What happens when metal is heated?", answers: [Answer(text: "It contracts", corret: false), Answer(text: "Metals don't get heated", corret: false), Answer(text: "Nothing happens", corret: false), Answer(text: "It expands", corret: true)]))
        
        quizzModels.append(Question(id: 3, text: "What are shooting stars?", answers: [Answer(text: "Shooting stars are stars heavier than gravity", corret: false), Answer(text: "They are bits of dust and rocks falling into the atmosphere", corret: true), Answer(text: "They are glowing balloons", corret: false), Answer(text: "Ther are a different type of rain", corret: false)]))
        
        quizzModels.append(Question(id: 4, text: "What are the world's biggest oxygen producer?", answers: [Answer(text: "Indoor plants, because of its quantity", corret: false), Answer(text: "Pythoplanktons are the biggest producers", corret: true), Answer(text: "All plants produce the same amount of oxygen", corret: false), Answer(text: "Trees are the biggest producers", corret: false)]))
        
        quizzModels.append(Question(id: 5, text: "What is an atom?", answers: [Answer(text: "Atoms are the smallest stars in universe", corret: false), Answer(text: "It's a chemical compound", corret: false), Answer(text: "One of the smallest pieces of matter", corret: true), Answer(text: "It's a law of physics", corret: false)]))
    }

}

extension QuizzViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureButtonConstraints(_ button: UIButton, _ footer: UIView) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: footer.topAnchor, constant: 40),
            button.bottomAnchor.constraint(equalTo: footer.bottomAnchor, constant: 10),
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
    
    private func setUpTabeCell(_ cell: AnswerTableViewCell, selectedCell: Bool) {
        cell.contentView.layer.borderWidth = 0.4
        cell.contentView.layer.cornerRadius = 5
        
        if selectedCell {
            cell.answerText.textColor = UIColor(named: "projectBlack")
            
            if answeredCorrectly! {
                cell.contentView.layer.borderColor = UIColor(named: "projectBackgroundGreen")!.cgColor
                cell.contentView.backgroundColor = UIColor(named: "projectBackgroundGreen")
                cell.imageMarkerView.tintColor = UIColor(named: "projectGreen")
            }
            else {
                cell.contentView.layer.borderColor = UIColor(named: "projectBackgroundRed")!.cgColor
                cell.contentView.backgroundColor = UIColor(named: "projectBackgroundRed")
                cell.imageMarkerView.tintColor = UIColor(named: "projectRed")
            }
        }
        else {
            cell.answerText.textColor = UIColor(named: "projectWhite")
            cell.contentView.layer.borderColor = UIColor(named: "projectWhite")!.cgColor
            cell.imageMarkerView.tintColor = UIColor(named: "projectWhite")
            cell.contentView.backgroundColor = UIColor.clear
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if answeredCorrectly != nil { // Has verified one answer
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
            let answer = currentQuestion!.answers[indexPath.section]
            
            if(answer.corret) {
                cell.configure(with: answer.text, markerName: "checkmark.circle.fill")
                setUpTabeCell(cell, selectedCell: selectedAnswer == indexPath.section)
            }
            else {
                cell.configure(with: answer.text, markerName: "xmark.circle.fill")
                setUpTabeCell(cell, selectedCell: selectedAnswer == indexPath.section)
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as! AnswerTableViewCell
            if(selectedAnswer != indexPath.section) {
                cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge")
            }
            else {
                cell.configure(with: currentQuestion!.answers[indexPath.section].text, markerName: "circlebadge.fill")
            }
            
            setUpTabeCell(cell, selectedCell: false)
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
