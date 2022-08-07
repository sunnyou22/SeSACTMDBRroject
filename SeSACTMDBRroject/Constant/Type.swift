//
//  Type.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/05.
//

import Foundation


struct MovieData {
    var releaseDate: Date
    var image: String
    var backdropPath: String // 굳이 필요할까
    var ganre: Int
    var rate: Double
    var title: String
    var overView: String
    var id: Int
}

struct CastData {
    var name: String
    var image: URL
    var roleNickname: String
}

struct MovieDetail {
    var overview: String
    var posterImage: String
    var backdropPath: String
}

class UserDefaultHelper {
    private init() { } // 외부사용 막고
    
    static let shared = UserDefaultHelper()
    
    enum Key: String {
        case movieID
    }
    
    let userDefaults = UserDefaults.standard
    var movieID: String {
        get {
            return userDefaults.string(forKey: Key.movieID.rawValue) ?? "0"
        }
        set {
            userDefaults.set(newValue, forKey: Key.movieID.rawValue)
        }
    }
}
