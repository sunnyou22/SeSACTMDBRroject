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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var characters: UILabel!
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var detailInfoLable: UILabel!
    @IBOutlet weak var forDetailButton: UIButton!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var scoreNumberLable: UILabel!
    @IBOutlet weak var clipButton: UIButton!
    
    let cornerRadiusValue: CGFloat = 12
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setFont()
        setColor()
        configureImage()
        configureContainView()
        configureButtonUI()
    }
    
    func setFont() {
        releaseDateLabel.font = .dateFont
        ganre.font = .systemBold20
        scoreLable.font = .normalFont
        scoreNumberLable.font = .normalFont
        title.font = .titleFont20
        characters.font = .subTitleFont18
        detailInfoLable.font = .normalFont
    }
    
    //MARK: Label, View 컬러
    func setColor() {
        ganre.textColor = .black
        scoreLable.textColor = .white
        scoreNumberLable.textColor = .black
        detailInfoLable.textColor = .black
        
        releaseDateLabel.textColor = .gray
        characters.textColor = .gray
        
        sectionView.backgroundColor = .black
        posterView.backgroundColor = .white
        scoreLable.backgroundColor = .systemPurple
        scoreNumberLable.backgroundColor = .white
    }
    
    func configureImage() {
        posterImage.contentMode = .scaleAspectFill
        posterImage.clipsToBounds = true
        posterImage.layer.cornerRadius = cornerRadiusValue
        posterImage.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    func configureContainView() {
        containerView.layer.borderColor = UIColor.lightGray.cgColor
//        containerView.layer.borderWidth = 0.2
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = cornerRadiusValue
        containerView.layer.masksToBounds = false
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 8
    }
    
    func configureButtonUI() {
        clipButton.setImage(UIImage(systemName: "paperclip"), for: .normal)
        clipButton.clipsToBounds = true
        clipButton.layer.cornerRadius = clipButton.bounds.height / 2.5
        clipButton.tintColor = .black
        clipButton.backgroundColor = .white
        forDetailButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        forDetailButton.tintColor = .black
    }
    
    func configureText() {
        scoreLable.text = "평점"
        scoreLable.textAlignment = .center
        
        scoreNumberLable.textAlignment = .center
        characters.lineBreakMode = .byTruncatingTail
        
        detailInfoLable.text = "자세히 보기"
        
    }
    
}
