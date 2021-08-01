//
//  AnswerTableViewCell.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 29/07/21.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    @IBOutlet var imageMarkerView: UIImageView!
    @IBOutlet var answerText: UILabel!
    
    static let identifier = "AnswerTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AnswerTableViewCell", bundle: nil)
    }
    
    public func configure(with text: String, markerName: String) {
        answerText.text = text
        imageMarkerView.image = UIImage(systemName: markerName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
