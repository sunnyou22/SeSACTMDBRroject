//
//  ViewController.swift
//  SeSACWeek6_Assignment
//
//  Created by 방선우 on 2022/08/09.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerTitle: UILabel!
    
    var postImageList: [[String]] = []
    var movieTitle: [String] = ["비슷한 영화", "현재상영중인 영화", "인기영화"]
    let color: [UIColor] = [.systemPink, .lightGray, .brown, .green]
    var bannerGanreDic: Dictionary<Int, String>?
    var movieDataList: [MovieData]?
    var ganreImageStringDic: Dictionary<String, [String]> = [:]
    var ganreImageStringDicList: [Dictionary<String, [String]>] = []
//    var testGanre: (() -> Dictionary<String, [String]>)?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var title = ""
      
        test()
        
        ganreImageStringDicList.randomElement()!.forEach({ key, value in
            title = key
        })
    bannerTitle.text = "\(title) 장르 영화들"
    bannerTitle.titleConfig()
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
        cell.titleLabel.text = movieTitle[indexPath.section]
        cell.setupUI(title: movieTitle[indexPath.section])
        cell.setSelected(false, animated: false)
        
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
            var count = 0
            ganreImageStringDicList.randomElement()!.forEach({ key, value in
               count = value.count
            })
            return count
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
            //            cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
            
//            guard let bannerGanreDic = self.bannerGanreDic else {
//                print("장르 키값오류")
//                return UICollectionViewCell() }
//            guard let movieDataList = self.movieDataList else {
//                print("무비리스트 못 가져옴")
//                return UICollectionViewCell() }
//
//            bannerGanreDic.forEach { key, value in
//                movieDataList.forEach { movieDate in
//                    movieDate.ganre.contains(key) ? ganreImageStringList.append(movieDate.image) : print("장르에 따른 포스터 이미지 받아오기 에러")
//                }
//            }
            
            let ganreImageStringList = test()
            
            let url: [[URL]] = ganreImageStringList.map { key, value in
                value.map { url in
                  URL(string: url)! }
            }
            
            cell.cardView.posterImageView.kf.setImage(with: url[0][indexPath.item])
            cell.cardView.posterImageView.contentMode = .scaleAspectFill
            
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
            print("시밀러")
            TrendManager.shared.requestRecommandPostImage(url: APIKey.NOWPLAY) { value in
                postImageList.append(value)
                print("지금")
                TrendManager.shared.requestRecommandPostImage(url: APIKey.POPULARMOVIE) { value in
                    postImageList.append(value)
                    print("인기")
                    completionHandler(postImageList)
                }
            }
        }
    }
}

extension MainViewController {
    
    @discardableResult
   private func test() -> Dictionary<String, [String]> {
        var imageList: [String] = []
        guard let bannerGanreDic = self.bannerGanreDic else {
            print("장르 키값오류")
            return [:] }
        guard let movieDataList = self.movieDataList else {
            print("무비리스트 못 가져옴")
            return [:] }
        
        bannerGanreDic.forEach { id, ganre in
            movieDataList.forEach { movieDate in
                guard movieDate.ganre.contains(id) else { return }
                    imageList.append(movieDate.image)
                ganreImageStringDic.updateValue(imageList, forKey: ganre)
                ganreImageStringDicList.append(ganreImageStringDic)
            }
        }
        return ganreImageStringDic
}
}

extension UILabel {
  fileprivate func titleConfig() {
        self.textColor = .white
        self.font = .systemFont(ofSize: 20, weight: .heavy)
        self.backgroundColor = .clear
    }
}
