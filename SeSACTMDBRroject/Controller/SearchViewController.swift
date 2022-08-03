//
//  SearchViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

class SearchViewController: UIViewController {
    var cellCount = 30
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 화면 데이터 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: CollectionViewCell.reuseIdentifer, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifer)
        
        //MARK: 네비
        navigationItem.title = "" // 첫 화면에 네비게이션 연결방법
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil) // 검색바 나오는 액션...
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        
        
        //MARK: api요청
        //        requestTMDBData()
        
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifer, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
                
                cell.requestTMDBData(index: indexPath, cellCount: 30)
        
        return cell
    }
    
    
}
