//
//  CollectionViewCell.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/04.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func requestTMDBData(index: IndexPath, cellCount: Int) {
        let url = APIKey.TMDBAPI + APIKey.TMDBAPI_ID
        
        AF.request(url, method: .get).validate(statusCode: 200...404).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var list: [URL] = []
                
                print("JSON: \(json)")
                
                for i in 1...cellCount {
                    list.append(URL(string: APIKey.TMDBIMAGE_W500 + json["results"][i]["known_for"][0]["poster_path"].stringValue) ?? URL(string: "https://kr.freepik.com/free-photos-vectors/x-symbol")!)
                }
                print(list)
            self.imageView.kf.setImage(with: list[index.row])
            self.imageView.contentMode = .scaleToFill
            let statusCode = response.response?.statusCode ?? 404 // 이렇게 statusCode를 해결할 수 있음
            
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
