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

import CustomFrameWork

class WebViewController: UIViewController {
    @IBOutlet weak var webview: WKWebView!
    
    var closeButton: UIBarButtonItem!
    var backwardButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var reloadButton: UIBarButtonItem!
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: WebViewController.self, action: nil)
    var items = [UIBarButtonItem]()
    
    var destinationURL = "https://www.youtube.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = false
        setButton()
        
        self.toolbarItems = items
        
        
        TrendManager.shared.callRequest(url: "\(APIKey.TMDBMOVIE)\(UserDefaultHelper.shared.movieID)/videos?api_key=\(APIKey.TMDBAPI_ID)&language=ko=KR") { json in
            TrendManager.shared.requestVideo(json: json) { url in
                self.openWebPage(url: url)
            }
        }
        
    }
    
    func setButton() {
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
