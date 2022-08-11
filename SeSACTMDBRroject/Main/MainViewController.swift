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
    
    var postImageList: [[String]] = []

    let color: [UIColor] = [.systemPink, .lightGray, .brown, .green]
    
    //컬렉션 뷰 내부 셀안에 숫자
    
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
        
        //api부르기
        requestRecommandPostImage { value in
            dump(value)
            self.postImageList = value
            DispatchQueue.main.async {
                self.mainTableView.reloadData()
            }
        }
    
        print(postImageList)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print(postImageList.count)
        return postImageList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell
        else { return UITableViewCell() }
        //
        //        cell.setupUI(title: movieTitle[indexPath.section])
        cell.backgroundColor = .black
        cell.contentsCollectionView.dataSource = self
        cell.contentsCollectionView.delegate = self
        cell.contentsCollectionView.tag = indexPath.section // 한줄을 통일하기 좋음
        cell.contentsCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 다차원 배열로 묶어서 인덱스를 비교하는 방법도 있음 -> 나중에 내가 알아볼 수 있을
        
//                if collectionView == bannerCollectionView {
//                    return color.count
//                } else if collectionView.tag == section {
//                    return postImageList[section].count
//                }
        
        if collectionView == bannerCollectionView {
            return color.count
        } else if collectionView.tag == 0 {
            return postImageList[collectionView.tag].count
        } else if collectionView.tag == 1 {
            return postImageList[collectionView.tag].count
        } else if collectionView.tag == 2 {
            return postImageList[collectionView.tag].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            let url = URL(string: postImageList[collectionView.tag][indexPath.row])
            cell.cardView.posterImageView.kf.setImage(with: url)
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

extension MainViewController {
    func requestRecommandPostImage(completionHandler: @escaping ([[String]]) -> ()) {
            
        var postImageList: [[String]] = []
        
            TrendManager.shared.requestRecommandPostImage(url: APIKey.SIMILARMOVIE) { value in
                postImageList.append(value)
    
                TrendManager.shared.requestRecommandPostImage(url: APIKey.LATESTMOVIE) { value in
                    postImageList.append(value)
    
                    TrendManager.shared.requestRecommandPostImage(url: APIKey.POPULARMOVIE) { value in
                        postImageList.append(value)
                        completionHandler(postImageList)
                    }
                }
            }
    }
}
