//
//  DetailTableViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/05.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher


// 로우한 값들 수정하기
class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var backdropPathImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet var searchTableView: UITableView!
    
    //MARK: - 프로퍼티 선언
    var movieDataList: MovieData?
    var castInfo: [CastData] = []
    var statPage = 1
    var isExpanded = false
    var recommandMovieList: [String] = []
    let sectionTitle = ["OverView", "Cast", "RecommandMovie"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let recommandURL = APIKey.TMDBMOVIE + UserDefaultHelper.shared.movieID + "/recommendations?api_key=" + APIKey.TMDBAPI_ID + "&language=en-US&page=1"
       
        requestPeopleData()
        setViewConfiguration()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        TrendManager.shared.requestRecommandPostImage(url: recommandURL) { value in
            self.recommandMovieList = value
            DispatchQueue.main.async {
                self.searchTableView.reloadData()
                
            }
        }
    }
    
    //MARK: - 테이블뷰
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return castInfo.count
        } else if section == 2 {
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let overViewCell = tableView.dequeueReusableCell(withIdentifier: OverVeiwTableViewCell.reuseIdentifier, for: indexPath) as? OverVeiwTableViewCell else {
                return UITableViewCell()
            }
            
            overViewCell.setFont()
            overViewCell.overview.text = movieDataList?.overView ?? "null"
            overViewCell.setSeparatorInset()
            return overViewCell
            
        } else if indexPath.section == 1 {
            let castIndex = castInfo[indexPath.row]
            guard let castCell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
            }
            castCell.setfont()
            castCell.setColor()
            castCell.castImage.layer.cornerRadius = 10
            // Kingfisher -> 쓰지않고 이미지 받아오기
            castCell.castImage.kf.setImage(with: castIndex.image)
            castCell.castname.text = castIndex.name
            castCell.character.text = castIndex.roleNickname
            castCell.setSeparatorInset()
            
            return castCell
            
        } else if indexPath.section == 2 {
            guard let recommandCell = tableView.dequeueReusableCell(withIdentifier: RecommandTableViewCell.reuseIdentifier, for: indexPath) as? RecommandTableViewCell else { return UITableViewCell() }
            
            recommandCell.contentsCollectionView.delegate = self
            recommandCell.contentsCollectionView.dataSource = self
            recommandCell.contentsCollectionView.register(UINib(nibName: CardCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
            
        return recommandCell
        }
    return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitle[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return 100
        } else if indexPath.section == 2 {
            return 190
        }
        
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @IBAction func expandButton(_ sender: UIButton) {
        isExpanded = !isExpanded
        tableView.reloadData()
    }
    
    func requestPeopleData() {
        
        TrendManager.shared.callRequest(url: APIKey.TMDBMOVIE + "\(UserDefaultHelper.shared.movieID)" + "/credits?api_key=" + APIKey.TMDBAPI_ID + "&language=en-US") { json in
            
            for item in json["cast"].arrayValue {
                
                let name = item["name"].stringValue
                let image = APIKey.TMDBPOSTERIMAGE_W780 + item["profile_path"].stringValue
                let castImageURL = URL(string: image)
                let roleNickname = item["character"].stringValue
                
                self.castInfo.append(CastData(name: name, image: castImageURL!, roleNickname: roleNickname))
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("===================")
            }
            
        }
    }
    
    func setViewConfiguration() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        backdropPathImage.kf.setImage(with: URL(string: movieDataList!.backdropPath))
        print(movieDataList!.backdropPath,"-------------")
        backdropPathImage.contentMode = .scaleToFill
        posterImage.kf.setImage(with: URL(string: movieDataList!.image))
        print(movieDataList!.image)
        posterImage.contentMode = .scaleToFill
        movieName.text = movieDataList?.title
        movieName.textColor = .white
        movieName.font = .systemBold20
    }
}

extension DetailTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 추천영화 수 (api)
        return recommandMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: recommandMovieList[indexPath.item])
        cell.cardView.posterImageView.kf.setImage(with: url)
        
        return cell
    }
}
