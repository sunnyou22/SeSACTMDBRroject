//
//  MapViewController.swift
//  SeSACTMDBRroject
//
//  Created by 방선우 on 2022/08/11.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showTheaterAlert))
//        showRequestLocatonServiceAlert()
    }
    
    // 지도 중심 기반
     func setRegionAndAnnotation(center: CLLocationCoordinate2D, index: Int?) {
        let therterList = TheaterList()
       
        // 위치 위경도구하기
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        // 영화관 여려개 설정 -> 반복문 함수 클로저
        
        // 어노테이션 선언
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        guard let index = index else {
            annotation.title = "새싹캠퍼스"
            mapView.addAnnotation(annotation)
            return
        }

        annotation.title = therterList.mapAnnotations[index].location
    
    // 지도에 핀 추가
        mapView.addAnnotation(annotation)
    }
    
}

extension MapViewController {
    
    // 디바이스 위치서비스 서비스 활성화 여부
    func checkUserDeviceLocationServiceAuthorization() {
        
    let authorizatonStatus: CLAuthorizationStatus
    
        //디바이스의 위치설정상태를 가져옴
        if #available(iOS 14.0, *) {
            authorizatonStatus = locationManager.authorizationStatus
        } else {
            authorizatonStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserDeviceLocationServiceAuthorization(authorizatonStatus)
        } else {
            showRequestLocatonServiceAlert()
        }
    
}
    
    func checkUserDeviceLocationServiceAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정창으로 오세요~")
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            setRegionAndAnnotation(center: center, index: nil)
        
        case .authorizedWhenInUse:
            let therterList = TheaterList()
            for i in 0...5 {
                setRegionAndAnnotation(center: CLLocationCoordinate2D(latitude: therterList.mapAnnotations[i].latitude, longitude: therterList.mapAnnotations[i].longitude), index: i)
                locationManager.startUpdatingLocation()
            }
            default: print("디폴트")
        }
    }
    
    func showRequestLocatonServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) {_ in
            
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancle = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(goSetting)
        requestLocationServiceAlert.addAction(cancle)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    //사용자의 위치를 잡아줄 건데 -> 뷰 디드
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}

extension MapViewController {
    
    @objc
    func showTheaterAlert() {
        let theaterList = TheaterList()
        
        //어노테이션 다 삭제
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)

        
        let alert = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet)
        
        let mega = UIAlertAction(title: theaterList.mapAnnotations[0].type, style: .default) { _ in
            self.testAnnotation(index: 0)
            
        }
        let lotte = UIAlertAction(title: theaterList.mapAnnotations[2].type, style: .default) { _ in
            self.testAnnotation(index: 2)
        }
        
        let cgv = UIAlertAction(title: "CGV", style: .default) { _ in
            self.testAnnotation(index: 4)
        }
        
        let allTheater = UIAlertAction(title: "전체보기", style: .default) { _ in
            self.testAnnotation(index: 0)
            self.testAnnotation(index: 2)
            self.testAnnotation(index: 4)

        }
        
        alert.addAction(mega)
        alert.addAction(lotte)
        alert.addAction(cgv)
        alert.addAction(allTheater)
        
        present(alert, animated: true, completion: nil)
        
    }

    func testAnnotation(index: Int) {
        
        let theaterList = TheaterList()
        let center_1 = CLLocationCoordinate2D(latitude: theaterList.mapAnnotations[index].latitude, longitude: theaterList.mapAnnotations[index].longitude)
        let center_2 = CLLocationCoordinate2D(latitude: theaterList.mapAnnotations[index + 1].latitude, longitude: theaterList.mapAnnotations[index + 1].longitude)
        let annotation_1 = MKPointAnnotation()
        let annotation_2 = MKPointAnnotation()
        
        let region_1 = MKCoordinateRegion(center: center_1, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let region_2 = MKCoordinateRegion(center: center_2, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region_1, animated: true)
        mapView.setRegion(region_2, animated: true)
        
        annotation_1.coordinate = center_1
        annotation_1.title = theaterList.mapAnnotations[index].location
        annotation_2.coordinate = center_2
        annotation_2.title = theaterList.mapAnnotations[index + 1].location
        
        self.mapView.addAnnotation(annotation_1)
        self.mapView.addAnnotation(annotation_2)
    }
}
