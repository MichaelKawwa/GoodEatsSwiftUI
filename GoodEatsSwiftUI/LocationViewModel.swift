//
//  LocationViewModel.swift
//  GoodEatsSwiftUI
//
//  Created by Michael Kawwa on 6/25/21.
//  Copyright © 2021 Michael Kawwa. All rights reserved.
//

import Foundation
import CoreLocation

class locationViewModel: NSObject, ObservableObject {
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0

    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension locationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
    }
}
