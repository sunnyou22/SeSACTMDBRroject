//
//  SearchViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "" // 첫 화면에 네비게이션 연결방법
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.triangle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil) // 검색바 나오는 액션...
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
//        requestTMDBData()
     
    }

    func requestTMDBData() {
        let url = APIKey.TMDBAPI + APIKey.TMDBAPI_ID
        
    AF.request(url, method: .get).validate(statusCode: 200...404).responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            print("JSON: \(json)")
            
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
