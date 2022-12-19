//
//  RecommandTableViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/10.
//

import UIKit

class RecommandTableViewCell: UITableViewCell {

    @IBOutlet weak var contentsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentsCollectionView.collectionViewLayout = collectionViewLayout()
    }

   // 타이틀은 테이블뷰 섹션 헤더로 넣어주기

    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 180)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
    
}
