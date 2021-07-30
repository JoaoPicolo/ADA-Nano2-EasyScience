//
//  CategoryTableViewCell.swift
//  NanoCrashChallenge2
//
//  Created by João Pedro Picolo on 30/07/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    static let identifier = "CategoryTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CategoryTableViewCell", bundle: nil)
    }
    
    public func configure(category: String, description: String, iconName: String) {
        categoryName.text = category
        categoryDescription.text = description
        imageIcon.image = UIImage(named: iconName)
    }
    
    @IBOutlet var imageIcon: UIImageView!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var categoryDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
