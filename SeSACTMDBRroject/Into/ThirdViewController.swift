//
//  ThirdViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        var config = UIButton.Configuration.filled()
        config.title = "시작하기"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .darkGray
        config.cornerStyle = .capsule
        startButton.configuration = config
        
        startButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        startButton.addAction(UIAction(handler: { [self] handler in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: SearchViewController.reuseIdentifier) as! SearchViewController
            let nav = UINavigationController(rootViewController: vc)
            
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }), for: .touchUpInside)
        
    }

}
