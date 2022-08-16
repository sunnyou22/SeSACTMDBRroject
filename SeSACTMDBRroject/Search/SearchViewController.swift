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
    var list: [MovieData] = []
    var ganrelist: Dictionary<Int, String> = [:]
    var idList: [Int] = []
    var totalCount = 0
    var startPage = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultHelper.shared.First = true
        
        //MARK: 화면 데이터 연결 및 페이지 네이션
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: CollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        
        //MARK: 레이아웃
        collectionView.collectionViewLayout = collectionViewLayout()
        
        //MARK: 네비
        setNavigation()
        
        //MARK: api요청
        requestTMDBData()
        requestGanre() //1, 서버통신 2.데이터를 가져왔는지 , 3. 데이터 형태확인
    }
    
    // cast정보로 overView 바꾸기 -> UserDefault
    func requestTMDBData() {
        
        TrendManager.shared.callRequest(url: APIKey.TMDBAPI + APIKey.TMDBAPI_ID) { json in
            print("JSON: \(json)")
            
            for item in json["results"].arrayValue {
                let image = APIKey.TMDBBACGROUNDIMAGE_W500 + item["poster_path"].stringValue
                let releaseDate = item["release_date"].stringValue
                let rate = item["vote_average"].doubleValue
                let title = item["title"].stringValue
                let overView = item["overview"].stringValue
                let movieganres = item["genre_ids"].arrayValue.map { $0.intValue }
                let backdropPath = APIKey.TMDBPOSTERIMAGE_W780 + item["backdrop_path"].stringValue
                let id = item["id"].intValue
                
                // 값을 받음
                let data = MovieData(releaseDate: releaseDate, image: image, backdropPath: backdropPath, ganre: movieganres, rate: rate, title: title, overView: overView, id: id)
                
                self.list.append(data)
                print(APIKey.TMDBGENRE)
                
                self.totalCount = json["total_results"].intValue
                
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func requestGanre() {
        
        TrendManager.shared.callRequest(url: APIKey.TMDBGENRE) { json in
            print(json["genres"].arrayValue.count)
            
            for i in json["genres"].arrayValue {
                let ganreID = i["id"].intValue
                let ganreName = i["name"].stringValue
                self.ganrelist.updateValue(ganreName, forKey: ganreID)
                self.idList.append(ganreID)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //날짜 계산
    func changeDate(date: String) -> String { // 순서대로 함수 진행
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: date)
        formatter.dateFormat = "MM/dd/yyyy"
        
        let resultDate = formatter.string(from: date!)
        
        return resultDate
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        // 장르불러오기
        let digit: Double = pow(10, 1)
        let url = URL(string: list[indexPath.row].image)
        
        let movie = list[indexPath.row]
        
        cell.posterImage.kf.setImage(with: url)
        cell.releaseDateLabel.text = changeDate(date: movie.releaseDate)
        cell.rateNumberLabel.text = String(round((movie.rate * digit) / digit))
        cell.movieTitle.text = movie.title
        cell.overview.text = movie.overView
        cell.ganre.text = ganrelist[movie.ganre[0]] //악 됐다...
        cell.clipButton.addTarget(self, action: #selector(goClipLink), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: DetailTableViewController.reuseIdentifier) as? DetailTableViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
        
        UserDefaultHelper.shared.movieID = "\(list[indexPath.row].id)"
        vc.movieDataList = list[indexPath.row]
    }
}

//MARK: 페이지 네이션
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 다운
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 1
                
                requestTMDBData()
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

extension SearchViewController { // 네비바 아이템 추가
    //MARK: 네비
    func setNavigation() {
        navigationItem.title = "MOVIE" // 첫 화면에 네비게이션 연결방법
        navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: #selector(goMain)), UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(goMap))]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(goClipLink)) // 검색바 나오는 액션...
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
    }
    
    @objc
    func goClipLink() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.reuseIdentifier) as? WebViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func goMap() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: MapViewController.reuseIdentifier) as? MapViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func goMain() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: MainViewController.reuseIdentifier) as? MainViewController else { return }

        //        vc.modalPresentationStyle = .fullScreen
        //        present(vc, animated: true)
        
        //MARK: 값전달
        vc.bannerGanreDic = self.ganrelist
        vc.movieDataList = self.list

        self.navigationController?.pushViewController(vc, animated: true)
    }
}
