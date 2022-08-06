//
//  Protocol.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/04.
//

import Foundation
import UIKit

protocol ReusableIdentifier {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension CollectionViewCell: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension DetailTableViewCell: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension OverVeiwTableViewCell: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
