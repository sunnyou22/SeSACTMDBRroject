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
}
