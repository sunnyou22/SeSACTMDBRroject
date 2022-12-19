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

//MARK: 서버통신
extension SearchViewController {
    
    func requestTMDBData() {
        
        TrendManager.shared.callRequest(url: APIKey.TMDBAPI + APIKey.TMDBAPI_ID) { [self] json in
            print("JSON: \(json)")
            requestTMDBTrendingData(json: json)
            TrendManager.shared.callRequest(url: APIKey.TMDBGENRE) { [self] json in
                print("JSON: \(json)")
                requestGanre(json: json)
            }
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    //trending 및 ganre 받아오는 메서드들
    func requestTMDBTrendingData(json: JSON) {
        
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
            self.totalCount = json["total_results"].intValue
            
            print(APIKey.TMDBGENRE)
        }
    }
    
    func requestGanre(json: JSON) {
        
        for i in json["genres"].arrayValue {
            let ganreID = i["id"].intValue
            let ganreName = i["name"].stringValue
            self.ganrelist.updateValue(ganreName, forKey: ganreID)
            self.idList.append(ganreID)
        }
    }
}
