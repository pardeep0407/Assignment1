//
//  MapViewController.swift
//  FifaWorldCup
//
//  Created by Pardeep on 01/07/19.
//  Copyright © 2019 Pardeep. All rights reserved.
//

import UIKit
import MapKit

//MARK: -
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var arrAnnotations : [MKPointAnnotation] = []
    
    //MARK: - UIViewcontroller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupMap()
    }
    
    //MARK: - Setups
    func setupMap(){
        self.clearMapView()
        self.addAnnotations()
    }
    
    func clearMapView(){
        for annotation in arrAnnotations{
            mapView.removeAnnotation(annotation)
        }
        arrAnnotations.removeAll()
    }
    
    func addAnnotations(){
        if AppDelegate.shared.arrMatchList.count > 0 {
            
            for sessionItme in AppDelegate.shared.arrMatchList{
                for matchItem in sessionItme.matches{
                    let center = CLLocationCoordinate2D(latitude: matchItem.mLatitude, longitude: matchItem.mLongitude)
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = center
                    pointAnnotation.title = matchItem.mMatchNumber
                    pointAnnotation.subtitle = matchItem.mStadium + " " + matchItem.mCity
                    mapView.addAnnotation(pointAnnotation)
                    arrAnnotations.append(pointAnnotation)
                }
                
            }
        }
        
        //To Fit All Marker in visible rect
        var zoomRect = MKMapRect.null
        for annotation in arrAnnotations{
            
            let annotationPoint = MKMapPoint.init(annotation.coordinate)
            let pointRect = MKMapRect.init(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        
        
        mapView.visibleMapRect = zoomRect
    }
    
    //MARK: - UIButton Actions
    
    //MARK: - NSNotifications
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(didGetSchedules), name: Notification.Name.init("Did_Get_Schedules"), object: nil)
    }
    
    @objc func didGetSchedules(){
        self.setupMap()
    }
}
