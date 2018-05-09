//
//  mapViewController.swift
//  learnswift
//
//  Created by QiHui Yan on 2018/5/7.
//  Copyright © 2018年 QiHui Yan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController,UISearchBarDelegate,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lat: UITextField!
    @IBOutlet var long: UITextField!
    let location = CLLocationManager()
    let point = MKPointAnnotation()
    lazy var getCoder:CLGeocoder = {
        return CLGeocoder()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.checkLocationAuth()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        userLocation.title = "老子在西方"
        userLocation.subtitle = "唐人街咯？"
        let center = userLocation.coordinate
        mapView.setCenter(center, animated: true)
        
        lat.text = String(center.latitude)
        long.text = String(center.longitude)
        
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        point.coordinate = center
        point.title = "扑街我系尼度"
        mapView.addAnnotation(point)
        mapView.selectAnnotation(point, animated: true)
        print(CLLocationManager.locationServicesEnabled())
    }
    
    @IBAction func submitLocation(_ sender: UIButton) {
        let mylat = (lat.text! as NSString).doubleValue
        let mylong = (long.text! as NSString).doubleValue
        let center = CLLocationCoordinate2DMake(mylat, mylong)
        let span = MKCoordinateSpanMake(1, 1)
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        point.coordinate = center
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuserId = "pin"
        let annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
        annView.pinTintColor = UIColor.blue
        annView.canShowCallout = true
        annView.animatesDrop = true
        return annView
    }
    
    func checkLocationAuth(){
        let alert = UIAlertController(title: "提示", message: "请求地址授权", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let act = UIAlertAction(title: "允许", style: .default) { (action:UIAlertAction) in
            UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }
        alert.addAction(cancel)
        alert.addAction(act)
        location.delegate = self
        location.requestAlwaysAuthorization()
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways:
                print("always")
            case .authorizedWhenInUse:
                print("once")
            default:
                present(alert, animated: true, completion: nil)
        }
        location.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let keyword = searchBar.text
        getCoder.geocodeAddressString(keyword!) { (pls:[CLPlacemark]?, error:Error?) in
            if error == nil {
                print("地名编译成功")
                guard let plsResult = pls else {return}
                print(plsResult)
                let firstPL = plsResult.first
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake((firstPL?.location?.coordinate)!, span)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
