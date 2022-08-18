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
     
     //MARK: - api 주소 요정 공통
     func callRequest(url: String, completionHandler: @escaping (JSON) -> ()) {

         AF.request(url, method: .get).validate().responseData() { response in
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
     
     //MARK: 상세화면에서 추천 영화 뜨게하기 -> 사이트url체킇
     func callRecommandRequest(url: String, completionHandler: @escaping ([String]) -> ()) {
        
         let url = url
         AF.request(url, method: .get).validate().responseData(queue: .global()) { response in
             switch response.result {
             case .success(let value):
                 let json = JSON(value)
                 let postPath = json["results"].arrayValue.map { postPath in
                     postPath["poster_path"].stringValue
                 }
                 print(postPath)
                 completionHandler(postPath)
                 // 큐 메인에서 리로드하기
             case .failure(let error):
                 print(error)
             }
         }
     }
     
     func requestRecommandPostImage(url: String, completionHandler: @escaping ([String]) -> ()) {
       
         var posterImageList: [String] = []
         callRecommandRequest(url: url) { imageList in
           posterImageList = imageList.map { APIKey.TMDBBACGROUNDIMAGE_W500 + $0 }
             completionHandler(posterImageList)
             }
         }
 
     //MARK: 비디오 요청
     func requestVideo(json: JSON, compleHandler: @escaping (String) -> ()) {
        
         var videoURL = ""

        let videoKey = json["results"][0]["key"].stringValue
        let site = json["results"][0]["site"].stringValue
        
        if site == "YouTube" {
                        videoURL = "https://www.youtube.com/watch?v=" + videoKey
        } else if site == "Vimeo" {
           
            videoURL = "https://vimeo.com/" + videoKey
        }
         compleHandler(videoURL)
    }
 }

//"\(APIKey.TMDBMOVIE)\(UserDefaultHelper.shared.movieID)/videos?api_key=\(APIKey.TMDBAPI_ID)&language=ko=KR"
