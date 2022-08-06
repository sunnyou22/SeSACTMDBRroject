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
    var backdropPath: String
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
