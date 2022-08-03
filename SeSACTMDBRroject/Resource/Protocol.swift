//
//  Protocol.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/04.
//

import Foundation
import UIKit

protocol ReusableIdentifier {
    static var reuseIdentifer: String { get }
}

extension UIViewController: ReusableIdentifier {
    static var reuseIdentifer: String {
        return String(describing: self)
    }
}

extension CollectionViewCell: ReusableIdentifier {
    static var reuseIdentifer: String {
        return String(describing: self)
    }
}
