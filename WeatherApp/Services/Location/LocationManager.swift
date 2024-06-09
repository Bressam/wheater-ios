//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Giovanne Bressam on 09/06/24.
//

import Foundation
import CoreLocation

struct CurrentLocationCoordinate {
    let latitude: LocationWeather.LocationDegrees
    let longitude: LocationWeather.LocationDegrees
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager?
    private var locationContinuation: CheckedContinuation<CurrentLocationCoordinate, Error>?

    override init() {
        self.locationManager = .init()
        super.init()
        self.locationManager?.delegate = self
    }
    
    private func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }

    func getCurrentLocation() async throws -> CurrentLocationCoordinate? {
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            let status = locationManager?.authorizationStatus
            if status == .authorizedAlways || status == .authorizedWhenInUse {
                locationManager?.requestLocation()
            } else {
                requestPermission()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        print("Lat: \(coordinate.latitude), Long: \(coordinate.longitude)")
        locationContinuation?.resume(returning: .init(latitude: coordinate.latitude,
                                                      longitude: coordinate.longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
    }
}
