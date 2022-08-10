//
//  OverVeiwTableViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/06.
//

import UIKit

class OverVeiwTableViewCell: UITableViewCell {

    @IBOutlet weak var overview: UILabel!
    
    func setFont() {
        overview.font = .normalFont
        overview.textColor = .black
    }
    
    func setSeparatorInset() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}
