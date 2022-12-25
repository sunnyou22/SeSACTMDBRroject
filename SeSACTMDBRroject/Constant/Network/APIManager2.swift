//
//  APIManager2.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/10.
//

import Foundation

 import Alamofire
 import SwiftyJSON

enum APIError: Error {
    case requestFail
    case recommandFail
}

class TrendManager {
    static let shared = TrendManager()
    
    private init() { }
    
    //MARK: - api 주소 요정 공통
    @discardableResult
    func callRequest(url: String) async throws -> JSON {
        let result: JSON = ""
        let request = AF.request(url, method: .get).validate()
        let dataTask = request.serializingData()
        
        switch await dataTask.result {
        case .success(let value):
            guard let response = await dataTask.response.response, (200...299).contains(response.statusCode) else {
                throw APIError.requestFail
            }
            let json = JSON(value)
            return json
        case .failure:
            print("네트워크 응답값 받아오기 실패 \(#function)")
        }
        return result
    }
    
    //MARK: 상세화면에서 추천 영화 뜨게하기 -> 사이트url체킇
    func callRecommandRequest(url: String) async throws -> [String] {
        let request = AF.request(url, method: .get).validate()
        let dataTask = request.serializingData()
        
        switch await dataTask.result {
        case .success(let value):
            guard let response = await dataTask.response.response,(200...299).contains(response.statusCode) else {
                throw APIError.recommandFail
            }
            let json = JSON(value)
            let postPath = json["results"].arrayValue.map { postPath in
                postPath["poster_path"].stringValue
            }
            print("4 callRecommandRequest, postpath : \(postPath)")
            return postPath
        case .failure(let error):
            print(error)
            
            return []
        }
    }
    
    func requestRecommandPostImage(url: String) async throws -> [String] {
        let imageList = try await callRecommandRequest(url: url)
        return imageList.map { APIKey.TMDBBACGROUNDIMAGE_W500 + $0 }
        print(imageList, " =================== \(url)")
    }
    
    //MARK: 비디오 요청
    @discardableResult
    func requestVideo(json: JSON) async throws -> String {
        
        var videoURL = ""
        
        let videoKey = json["results"][0]["key"].stringValue
        let site = json["results"][0]["site"].stringValue
        
        if site == "YouTube" {
            videoURL = "https://www.youtube.com/watch?v=" + videoKey
        } else if site == "Vimeo" {
            
            videoURL = "https://vimeo.com/" + videoKey
        }
        return videoURL
    }
}

//MARK: 서버통신
extension SearchViewController {
    
    func requestTMDBData() async throws {
        let trendData = try await TrendManager.shared.callRequest(url: APIKey.TMDBAPI + APIKey.TMDBAPI_ID)
        requestTMDBTrendingData(json: trendData)
        let ganreData = try await TrendManager.shared.callRequest(url: APIKey.TMDBGENRE)
        requestGanre(json: ganreData)
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
