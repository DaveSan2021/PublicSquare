//
//  CustomTableViewCell.swift
//  PublicSquare
//
//  Created by Dave Sanyal on 3/22/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var forthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    
    
    @IBOutlet weak var textRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
