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

    //MARK: - UIViewcontroller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupMap()
    }
    
    //MARK: - Setups
    func setupMap(){
        self.addAnnotations()
    }
    
    func addAnnotations(){
        if AppDelegate.shared.arrMatchList.count > 0 {
            
            let matchItem = AppDelegate.shared.arrMatchList.first!
            
            let center = CLLocationCoordinate2D(latitude: matchItem.matches.first!.mLatitude, longitude: matchItem.matches.first!.mLongitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
            mapView.setRegion(region, animated: true)
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = center
            pointAnnotation.title = matchItem.matches.first!.mMatchNumber
            pointAnnotation.subtitle = matchItem.matches.first!.mAddress
            mapView.addAnnotation(pointAnnotation)
        }
    }

    //MARK: - UIButton Actions
}
