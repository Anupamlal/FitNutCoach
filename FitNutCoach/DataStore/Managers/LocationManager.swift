//
//  LocationManager.swift
//  FitNutCoach
//
//  Created by Anupam Kumar Lal on 02/10/25.
//

import Foundation
import CoreLocation
import Combine

struct PlaceDetails: Codable {
    let latitude: Double
    let longitude: Double
    let name: String?
    let state: String?
    let country: String?
}

final class LocationManager: NSObject, ObservableObject {
    @Published var placeDetails: PlaceDetails?
    @Published var authorizationStatus: CLAuthorizationStatus?

    private let locationManager = CLLocationManager()
    private var oldLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocationAccess(oldLocation: CLLocation? = nil) {
        self.oldLocation = oldLocation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location access denied or restricted.")
        case .notDetermined:
            print("🔄 Waiting for user to grant permission.")
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        // Reverse geocode to get place details
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("❌ Reverse geocoding failed: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemarks?.first, let weakSelf = self else { return }

            let name = placemark.locality ?? placemark.name
            let state = placemark.administrativeArea
            let country = placemark.country
            
            let updatedPlaceDetails = PlaceDetails(
                latitude: latitude,
                longitude: longitude,
                name: name,
                state: state,
                country: country
            )

            DispatchQueue.main.async {
                
                if let oldLocation = weakSelf.oldLocation {
                    let distance = location.distance(from: oldLocation)
                    print("Distance from last location: \(distance) meters")
                    
                    if distance > AppConstants.thresholdDistance {
                        weakSelf.updatePlaceAndOldLoc(with: location, updatedPlaceDetails: updatedPlaceDetails)
                    }
                    
                }else {
                    weakSelf.updatePlaceAndOldLoc(with: location, updatedPlaceDetails: updatedPlaceDetails)
                }
                
            }
        }

        // Stop updates after first location (optional)
        locationManager.stopUpdatingLocation()
    }
    
    private func updatePlaceAndOldLoc(with newLocation: CLLocation, updatedPlaceDetails: PlaceDetails) {
        if updatedPlaceDetails.name != nil {
            self.oldLocation = newLocation
            self.placeDetails = updatedPlaceDetails
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
    }
}

