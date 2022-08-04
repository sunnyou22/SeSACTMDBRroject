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
    
    var list: [MovieData] = []
    var ganrelist: [(Int, String)] = []
    var totalCount = 0
    var startPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: 화면 데이터 연결 및 페이지 네이션
        collectionView.prefetchDataSource = self
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
        
        collectionView.collectionViewLayout = collectionViewLayout()
        
        //MARK: api요청
        requestTMDBData()
        
    }
    
    func requestGanre() {
        let url = APIKey.TMDBGENRE
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in json["genre_ids"].arrayValue {
                    let ganreID = i["id"].intValue
                    let ganreName = i["name"].stringValue
                    self.ganrelist.append((ganreID, ganreName))
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestTMDBData() {
        let url = APIKey.TMDBAPI + APIKey.TMDBAPI_ID
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM/dd/yyyy"
        AF.request(url, method: .get).validate(statusCode: 200...404).responseData { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let statusCode = response.response?.statusCode ?? 404 // 이렇게 statusCode를 해결할 수 있음
                print("JSON: \(json)")
                
                for item in json["results"].arrayValue {
                    let image = APIKey.TMDBIMAGE_W500 + item["poster_path"].stringValue
                    let releaseDate = item["release_date"].stringValue
                    let genre = item["genre_ids"]["id"].arrayValue
                    let rate = item["vote_average"].doubleValue
                    let title = item["title"].stringValue
                    let overView = item["overview"].stringValue
                    
                    let data = MovieData(releaseDate: releaseDate, image: image, rate: rate, ganre: genre, title: title, overView: overView)
                    
                    self.list.append(data)
                    print(APIKey.TMDBGENRE)
                    
                    self.totalCount = json["total_results"].intValue
                    
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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM/dd/yyy"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifer, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        // 장르불러오기
        let digit: Double = pow(10, 1)
        let url = URL(string: list[indexPath.row].image)
        
        cell.posterImage.kf.setImage(with: url)
        cell.releaseDateLabel.text = list[indexPath.row].releaseDate
        cell.rateNumberLabel.text = String(round((list[indexPath.row].rate * digit) / digit))
        cell.movieTitle.text = list[indexPath.row].title
        cell.overview.text = list[indexPath.row].overView
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailTableViewController.reuseIdentifer) as? DetailTableViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 다운
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count == indexPath.item && list.count < totalCount {
                startPage += 1 // 흠 셀의 크기가 너무 커서 하나마나인가..?
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("==============취소")
    }
}

extension SearchViewController {
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.2)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        //        layout.minimumInteritemSpacing = spacing * 2 // 행에 많이 있을 때
        layout.minimumLineSpacing = spacing * 2
       return layout
    }
}
