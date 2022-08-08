//
//  APIManager.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/05.
//

import Foundation

import Alamofire
import SwiftyJSON

class TrendManager {
    static let shared = TrendManager()
    
    func callRequest(type: EndPoint, completionHandler: @escaping (JSON) -> ()) {
        
        let url = type.requestURL
        
        AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
                
                // 큐 메인에서 리로드하기
            case .failure(let error):
                print(error)
            }
        }
    }
}
