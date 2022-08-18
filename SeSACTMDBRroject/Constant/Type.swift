//
//  Type.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/05.
//

import Foundation
import SwiftyJSON


struct MovieData {
    var releaseDate: String
    var image: String
    var backdropPath: String // 굳이 필요할까
    var ganre: [Int]
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

//struct MovieDetail {
//    var name
//    var overview: String
//    var posterImage: String
//    var backdropPath: String
//}

class UserDefaultHelper {
    private init() { } // 외부사용 막고
    
    static let shared = UserDefaultHelper()
    
    enum Key: String {
        case movieID
        case First
        case clipstate
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
    
    var First: Bool {
        get  {
            return userDefaults.bool(forKey: Key.First.rawValue) 
        }
        set  {
            userDefaults.set(newValue, forKey: Key.First.rawValue)
        }
    }
    var clipstate: Bool {
        get {
            return userDefaults.bool(forKey: Key.clipstate.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.clipstate.rawValue)
        }
    }
}

/*
 TheaterList
 */

struct Theater {
    let type: String
    let location: String
    let latitude: Double
    let longitude: Double
}

struct TheaterList {
    var mapAnnotations: [Theater] = [
        Theater(type: "롯데시네마", location: "롯데시네마 서울대입구", latitude: 37.4824761978647, longitude: 126.9521680487202),
        Theater(type: "롯데시네마", location: "롯데시네마 가산디지털", latitude: 37.47947929602294, longitude: 126.88891083192269),
        Theater(type: "메가박스", location: "메가박스 이수", latitude: 37.48581351541419, longitude:  126.98092132899579),
        Theater(type: "메가박스", location: "메가박스 강남", latitude: 37.49948523972615, longitude: 127.02570417165666),
        Theater(type: "CGV", location: "CGV 영등포", latitude: 37.52666023337906, longitude: 126.9258351013706),
        Theater(type: "CGV", location: "CGV 용산 아이파크몰", latitude: 37.53149302830903, longitude: 126.9654030486416)
    ]
}
