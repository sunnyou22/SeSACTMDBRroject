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
    var rate: Double
    var ganre: [JSON]
    var title: String
    var overView: String
}
