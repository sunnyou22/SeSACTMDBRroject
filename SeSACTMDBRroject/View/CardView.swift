//
//  CardView.swift
//  SeSACWeek6_Assignment
//
//  Created by 방선우 on 2022/08/09.
//

import UIKit

class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentsLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        let view = UINib(nibName: CardView.reuseIdentifier, bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        
        view.layer.cornerRadius = 10
        view.backgroundColor = .black
        self.addSubview(view) // 스스로에게 이 뷰를 쓴다고 말하는 것
    }
}
