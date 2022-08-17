//
//  IntroViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/16.
//

import UIKit

class IntroViewController: UIPageViewController {

    var pageViewControllerList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 함수 순서 헷갈리지 않기
        createPageViewContrller()
        configurePageViewController()
        
    }
    
    func createPageViewContrller() {
        let sb = UIStoryboard(name: "Intro", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: FirstViewController.reuseIdentifier) as! FirstViewController
        let vc2 = sb.instantiateViewController(withIdentifier: SecondViewController.reuseIdentifier) as! SecondViewController
        let vc3 = sb.instantiateViewController(withIdentifier: ThirdViewController.reuseIdentifier) as! ThirdViewController
        
        pageViewControllerList = [vc1, vc2, vc3]
    }
    
    func configurePageViewController() {
        
        // 여기서는 특정 뷰가 아니라 뷰컨 자체에 걸어줘야하니까
        delegate = self
        dataSource = self
        
        //display ❓왜 배열로 받아줘야하는 거야? 한페이지에 여러개를 보여줄 수 있기 때문
        guard let first = pageViewControllerList.first else { return } // 배열에 첫번째 요소가 있어?  ㅇㅇ
        setViewControllers([first], direction: .forward, animated: true)
    }
}

extension IntroViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        //현재 보이는 뷰컨의 인덱스를 가져오기
        guard let viewcontrollerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewcontrollerIndex - 1
        
        return previousIndex < 0 ? nil : pageViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewcontrollerIndex = pageViewControllerList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = viewcontrollerIndex + 1
        
        return nextIndex >= pageViewControllerList.count ? nil : pageViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        // 현재화면에서 보이고 있는 뷰가 첫번째 뷰냐?  = 뷰가 있냐 /ㅇㅇ, 오케 그럼 그 뷰 인덱스 가져와
        guard let first = viewControllers?.first, let index = pageViewControllerList.firstIndex(of: first) else { return 0 }
        return index
    }
    
}
