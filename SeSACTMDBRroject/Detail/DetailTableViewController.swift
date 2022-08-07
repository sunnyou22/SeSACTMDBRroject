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

class DetailTableViewController: UITableViewController {
    
    @IBOutlet weak var backdropPathImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    //
    var movieDataList: MovieData?
    var castInfo: [CastData] = []
    var statPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPeopleData()
        setCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        
        if section == 0 {
            return 1
        } else {
            return castInfo.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 하나의 셀을 계속 반복하면서 그려줌 Cellforrowat에서는 어떤 셀이든 castinfo 인덱스를 호출하고 있어서 섹션 내 셀 갯수와 셀 데이터가 맞지 않아 보여요 선우님
        
        // 해당셀에 이미 셀의 갯수를 정해놓은 상황, 그 인덱스에 맞는 정보를 매칭해서 셀에 그려주려고함. 근데 castinfo를 섹션 안의 갯수와 맞지 않게 0번에서 불러주고있기 때문에 인덱스 오류가 난 것
        
        if indexPath.section == 1 {
            let castIndex = castInfo[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
            }
            cell.setfont()
            cell.setColor()
            cell.castImage.layer.cornerRadius = 10
            // Kingfisher -> 쓰지않고 이미지 받아오기
            cell.castImage.kf.setImage(with: castIndex.image)
            cell.castname.text = castIndex.name
            cell.character.text = castIndex.roleNickname
            cell.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) // 적용안됨
            return cell
            
        } else if indexPath.section == 0 {
            guard let cell2 = tableView.dequeueReusableCell(withIdentifier: OverVeiwTableViewCell.reuseIdentifier, for: indexPath) as? OverVeiwTableViewCell else {
                return UITableViewCell()
            }
            
            cell2.setFont()
            cell2.overview.text = movieDataList?.overView ?? "null"
            return cell2
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "OverView" : "Cast"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func requestPeopleData() {
        
        let url = APIKey.TMDBMOVIE + "\(UserDefaultHelper.shared.movieID)" + "/credits?api_key=" + APIKey.TMDBAPI_ID + "&language=en-US" // moviewID에 해당셀의 인덱스 걸어주기
        
        //======
        AF.request(url, method: .get).validate().responseData { response in
            print(url)
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for item in json["cast"].arrayValue {
                    
                    let name = item["name"].stringValue
                    let image = APIKey.TMDBPOSTERIMAGE_W780 + item["profile_path"].stringValue
                    let castImageURL = URL(string: image)
                    let roleNickname = item["character"].stringValue
                    
                    self.castInfo.append(CastData(name: name, image: castImageURL!, roleNickname: roleNickname))
                    print(self.castInfo.count)
                }
                
                self.tableView.reloadData()
                print("===================")
            case .failure(let error):
                print(error)
            }
        }
    }
    func setCell() {
        backdropPathImage.kf.setImage(with: URL(string: movieDataList!.backdropPath))
        backdropPathImage.contentMode = .scaleToFill
        posterImage.kf.setImage(with: URL(string: movieDataList!.image))
        posterImage.contentMode = .scaleToFill
        movieName.text = movieDataList?.title
        movieName.textColor = .white
        movieName.font = .systemBold20
    }
}
