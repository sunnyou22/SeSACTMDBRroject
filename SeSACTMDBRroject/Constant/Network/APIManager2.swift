//
//  APIManager2.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/10.
//

import Foundation

 import Alamofire
 import SwiftyJSON

 class TrendManager {
     static let shared = TrendManager()

     private init() { }
     
     func callRequest(url: String, completionHandler: @escaping (JSON) -> ()) {

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
     
     func callRecommandRequest(completionHandler: @escaping ([String]) -> ()) {
         let url = APIKey.TMDBMOVIE + UserDefaultHelper.shared.movieID + "/recommendations?api_key=" + APIKey.TMDBAPI_ID + "&language=en-US&page=1"
         AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
             switch response.result {
             case .success(let value):
                 let json = JSON(value)
                 let postPath = json["results"].arrayValue.map { postPath in
                     postPath["poster_path"].stringValue
                 }

                 completionHandler(postPath)
                 // 큐 메인에서 리로드하기
             case .failure(let error):
                 print(error)
             }
         }
     }
     
     func requestRecommandPostImage(completionHandler: @escaping ([String]) -> ()) {
         var posterImageList: [String] = []
         callRecommandRequest { imageList in
           posterImageList = imageList.map { APIKey.TMDBBACGROUNDIMAGE_W500 + $0 }
             completionHandler(posterImageList)
             }
         }
 }

