//
//  FirstViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit
import SnapKit

class FirstViewController: UIViewController {
    
    let introMentLabel: UILabel = {
        let view = UILabel()
        view.text = """
오늘도 밥먹으면서
영화도 냠냠합시다
"""
        view.font = .boldSystemFont(ofSize: 25)
        view.numberOfLines = 0
        view.textColor = .white
        
        return view
    }()
    
    let toStartImageView: UIImageView = {
        let view = UIImageView()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold)
        view.tintColor = .white
        view.image = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: imageConfig)
        
        return view
    }()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //매개변수 이름을 view로 하면 안됨 -> 인식을 못함
        [introMentLabel, toStartImageView].forEach {
            view.addSubview($0)
        }
        
        introMentLabel.alpha = 0
        UIView.animate(withDuration: 2) {
            self.introMentLabel.alpha = 1
        } completion: { _ in
            self.animateArrowImageView()
        }
        
        config()
    }
    
    func animateArrowImageView() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
            self.toStartImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            //            <#code#>
        }
    }
    
    func config() {
        introMentLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30) // safeArea를 기준으로 하고 싶으면
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        toStartImageView.snp.makeConstraints { make in
            make.top.equalTo(introMentLabel.snp.bottom).offset(300)
            make.centerX.equalTo(view)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
}
