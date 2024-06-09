//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 09/06/24.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didReceiveCurrentLocation(latitude: Double, longitude: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?

    override init() {
        self.locationManager = .init()
        super.init()
        self.locationManager?.delegate = self
    }
    
    private func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() {
        let status = locationManager?.authorizationStatus
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        } else {
            requestPermission()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Auth provided")
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")
        manager.stopUpdatingLocation()
        delegate?.didReceiveCurrentLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
