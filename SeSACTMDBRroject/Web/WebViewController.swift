//
//  WebViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/08.
//

import UIKit
import WebKit

import Alamofire
import SwiftyJSON

class WebViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    
    var items = [UIBarButtonItem]()
    var closeButton: UIBarButtonItem!
    var backwardButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var reloadButton: UIBarButtonItem!
    var flag: Bool {
        get {
            UserDefaultHelper.shared.clipstate
        }
        set {
            UserDefaultHelper.shared.clipstate = newValue
        }
    }
    
    var clipButtonActionHandler: ((Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "클립", style: .plain, target: self, action: #selector(clikedClip))
        
        self.toolbarItems = items
    
    }
    
    func openwebpage() async throws {
        
        let json = try await TrendManager.shared.callRequest(url: "\(APIKey.TMDBMOVIE)\(UserDefaultHelper.shared.movieID)/videos?api_key=\(APIKey.TMDBAPI_ID)&language=ko=KR")
        let url = try await TrendManager.shared.requestVideo(json: json)
        self.openWebPage(url: url)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setButton()
    }
    
    //MARK: 클립 bool상태 바꾸기 코드
    @objc
    func clikedClip() {
        let alert = UIAlertController(title: "보고싶은 영화", message: "현재 영화를 클립하시겠습니까?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { [self]_ in
            flag = true
            print(flag)
            self.clipButtonActionHandler?(flag)
        }
        let no = UIAlertAction(title: "NO", style: .destructive) { [self] _ in
            flag = false
            print(flag)
            self.clipButtonActionHandler?(flag)
        }
        alert.addAction(ok)
        alert.addAction(no)
        
        present(alert, animated: true) {
        }
    }
    
    func setButton() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexibleSpace.width = 30

        closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeWebView))
        
        backwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(gobackButtonCilcked))
        forwardButton = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(goforwardButton))
        reloadButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(reloadWebView))
        [closeButton, flexibleSpace, backwardButton, flexibleSpace, reloadButton, flexibleSpace, forwardButton].forEach {
            items.append($0)
        }
    }
    
    @objc
    func gobackButtonCilcked() {
        if webview.canGoBack {
            webview.goBack()
        }
    }
    
    @objc
    func goforwardButton() {
        if webview.canGoForward {
            webview.goForward()
        }
    }
    
    @objc
    func reloadWebView() {
        webview.reload()
    }
    
    @objc
    func closeWebView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openWebPage(url: String) {
        
        guard let url = URL(string: url) else {
            print("알 수 없는 URL")
            return
        }
        let request = URLRequest(url: url)
        self.webview.load(request)
    }
}
