//
//  CardCollectionViewCell.swift
//  SeSACWeek6_Assignment
//
//  Created by 방선우 on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setupUI() // 이 셀 자체의 고정값 디폴트라고 볼 수 있을듯?
    }

    //cardView에 채택
   private func setupUI() {
        
        cardView.clipsToBounds = true
        cardView.backgroundColor = .clear
        cardView.posterImageView.contentMode = .scaleToFill
        cardView.posterImageView.backgroundColor = .lightGray
        cardView.posterImageView.layer.cornerRadius = 10
        cardView.frame = .zero
        cardView.likeButton.tintColor = .systemPink
    }
}
