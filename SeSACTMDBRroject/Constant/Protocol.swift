//
//  Protocol.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/04.
//


import UIKit

protocol ReusableIdentifier {
    static var reuseIdentifier: String { get }
}

extension UIViewController: ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableIdentifier {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
