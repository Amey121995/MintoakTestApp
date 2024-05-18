//
//  filterCategoryCell.swift
//  Minty
//
//  Created by Niket on 30/08/22.
//

import UIKit

class filterCategoryCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkBoxImg: UIImageView!
    
    @IBOutlet weak var parentImageVw: UIView!
    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var parentArrowImg: UIView!
    @IBOutlet weak var arrowImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
