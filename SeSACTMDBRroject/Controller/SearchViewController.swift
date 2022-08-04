//
//  SearchViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
  
    var list: [String] = []
    
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
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        layout.minimumInteritemSpacing = spacing * 2 // 행에 많이 있을 때
        layout.minimumLineSpacing = spacing * 2
        collectionView.collectionViewLayout = layout
        
        //MARK: api요청
                requestTMDBData()
        
    }
    
    func requestTMDBData() {
        let url = APIKey.TMDBAPI + APIKey.TMDBAPI_ID
        
        AF.request(url, method: .get).validate(statusCode: 200...404).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let statusCode = response.response?.statusCode ?? 404 // 이렇게 statusCode를 해결할 수 있음
                print("JSON: \(json)")
                
                for item in json["results"].arrayValue {
                    self.list.append(APIKey.TMDBIMAGE_W500 + item["poster_path"].stringValue)
                  
                    print(self.list, "패치")
                }
                self.collectionView.reloadData()

                if statusCode == 200 {
                    print(statusCode)
                } else {
                    print(json["status_message"].stringValue)
            }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifer, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let url = URL(string: list[indexPath.row])
        cell.posterImage.kf.setImage(with: url)
        
        return cell
    }
    
    
}
