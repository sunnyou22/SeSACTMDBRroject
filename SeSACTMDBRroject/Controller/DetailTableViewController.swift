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
    @IBOutlet weak var overView: UITextView!
    
    
    var movieDataList: [MovieData]?
    var castInfo: [CastData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPeopleData()
    }
    
    func requestPeopleData() {
        
        let url = APIKey.TMDBMOVIE + "\(UserDefaultHelper.shared.movieID)" + "credits?api_key=" + APIKey.TMDBAPI_ID + "&language=en-US" // moviewID에 해당셀의 인덱스 걸어주기
        
        // Thread로
        AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
            
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
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
               
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  castInfo.count

        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.reuseIdentifier, for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
            }

        
            
           if indexPath.section == 1 {
               let castIndex = castInfo[indexPath.row]
            // Kingfisher -> 쓰지않고 이미지 받아오기
            cell.castImage.kf.setImage(with: castIndex.image)
            cell.castname.text = castIndex.name
            cell.character.text = castIndex.roleNickname
               
               
//           } else {
//               let castIndex = castInfo[indexPath.row]
//                cell1.overview.text = castIndex.roleNickname // overView로 바구주기
//
//               return cell1
            }
            return cell
            
        }

        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return section == 0 ? "OverView" : "Cast"
        }
    
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    
//        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//            <#code#>
//        }
}
