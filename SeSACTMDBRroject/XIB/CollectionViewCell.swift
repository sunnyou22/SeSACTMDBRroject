//
//  CollectionViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/04.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ganre: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var detailInfoLable: UILabel!
    @IBOutlet weak var forDetailButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    @IBOutlet weak var clipButton: UIButton!
    
    let cornerRadiusValue: CGFloat = 12
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFont()
        setColor()
        configureImage()
        configureContainView()
        configureButtonUI()
        configureText()
    }
    
   private func setFont() {
        releaseDateLabel.font = .dateFont
        ganre.font = .systemBold20
        rateLabel.font = .normalFont
        rateNumberLabel.font = .normalFont
        movieTitle.font = .titleFont20
        overview.font = .subTitleFont18
        detailInfoLable.font = .normalFont
    }
    
    //MARK: Label, View 컬러
   private func setColor() {
        ganre.textColor = .black
        rateLabel.textColor = .white
        rateNumberLabel.textColor = .black
        detailInfoLable.textColor = .black
        
        releaseDateLabel.textColor = .gray
        overview.textColor = .gray
        
        sectionView.backgroundColor = .black
        posterView.backgroundColor = .white
        rateLabel.backgroundColor = .systemPurple
        rateNumberLabel.backgroundColor = .white
    }
    
   private func configureImage() {
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = cornerRadiusValue
        posterImage.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    private func configureContainView() {
        containerView.layer.borderColor = UIColor.lightGray.cgColor
//        containerView.layer.borderWidth = 0.2
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = cornerRadiusValue
//        containerView.clipsToBounds = false
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 8
    }
    
   private func configureButtonUI() {
        clipButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        clipButton.clipsToBounds = true
        clipButton.layer.cornerRadius = clipButton.bounds.height / 2
        clipButton.tintColor = .black
        clipButton.backgroundColor = .white
        forDetailButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        forDetailButton.tintColor = .black
    }
    
   private func configureText() {
        rateLabel.text = "평점"
        rateLabel.textAlignment = .center
        
        rateNumberLabel.textAlignment = .center
        overview.lineBreakMode = .byTruncatingTail
        
        detailInfoLable.text = "자세히 보기"
        
    }
    
}
