//
//  OverVeiwTableViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/06.
//

import UIKit

class OverVeiwTableViewCell: UITableViewCell {

    @IBOutlet weak var overview: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        overview.font = .normalFont
        overview.textColor = .black
    }
}
