//
//  ColorCell.swift
//  testProject
//
//  Created by Sferea-Lider on 19/12/22.
//

import UIKit

class ColorCell: UITableViewCell {

    @IBOutlet weak var colorLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    static let identifier = "ColorCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
