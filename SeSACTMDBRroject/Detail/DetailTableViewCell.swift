//
//  DetailTableViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/05.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castname: UILabel!
    @IBOutlet weak var character: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setfont()
        setColor()
        setSeparatorInset()
        
    }
    
    // 프로토콜로 만들기
   private func setfont() {
        castname.font = .subTitleBoldFont18
        character.font = .normalFont
    }
    
   private func setColor() {
        castname.textColor = .black
        character.textColor = .gray
    }

   private func setSeparatorInset() {
        self.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        self.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }

}
