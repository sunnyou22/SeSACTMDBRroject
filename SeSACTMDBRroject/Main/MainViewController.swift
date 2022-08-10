//
//  ViewController.swift
//  SeSACWeek6_Assignment
//
//  Created by 방선우 on 2022/08/09.
//

import UIKit

class MainViewController: UIViewController {
    

  
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    let color: [UIColor] = [.systemPink, .lightGray, .brown, .green]
    let movieTitle: [String] = ["아는 와이프와 비슷한 콘텐츠", "미스터 션샤인과 비슷한 콘텐츠", "액션 SF", "미국 TV프로그램"]
    
    //컬렉션 뷰 내부 셀안에 숫자
    let numberList: [[Int]] = [
        [Int](1...10),
        [Int](30...36),
        [Int](50...58),
        [Int](1000...1012)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.collectionViewLayout = collectionViewlayout()
         
        mainTableView.separatorInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell
        else { return UITableViewCell() }
        
        cell.setupUI(title: movieTitle[indexPath.section])
        cell.backgroundColor = .black
        cell.contentsCollectionView.dataSource = self
        cell.contentsCollectionView.delegate = self
        cell.contentsCollectionView.tag = indexPath.section // 한줄을 통일하기 좋음
        cell.contentsCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (180 + 8 + 8 + 16 + 28)
    }
    
   
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : numberList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.posterImageView.backgroundColor = .brown
            cell.cardView.contentsLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            cell.cardView.contentsLabel.textColor = .white
        }
        
        return cell
    }
    
    func collectionViewlayout() -> UICollectionViewFlowLayout { // 레이아웃을 따로 빼
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return layout
    }
}
