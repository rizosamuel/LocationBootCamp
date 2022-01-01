//
//  LocationManager.swift
//  LocationBootCamp
//
//  Created by Rijo Samuel on 01/01/22.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
	
	static let shared = LocationManager()
	
	private let manager = CLLocationManager()
	
	private var completion: ((CLLocation) -> Void)?
	
	override private init() {}
	
	func getUserLocation(completion: @escaping (CLLocation) -> Void) {
		
		self.completion = completion
		manager.requestWhenInUseAuthorization()
		manager.delegate = self
		manager.startUpdatingLocation()
	}
	
	func resolveLocationName(with location: CLLocation, completion: @escaping (String?) -> Void) {
		
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
			
			guard let place = placemarks?.first, error == nil else {
				completion(nil)
				return
			}
			
			print(place)
			
			var name = ""
			
			if let locality = place.locality {
				name += locality
			}
			
			if let adminArea = place.administrativeArea {
				name += ", \(adminArea)"
			}
			
			completion(name)
		}
	}
}

// MARK: - Location Delegate Methods
extension LocationManager: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		guard let location = locations.first else { return }
		
		completion?(location)
		manager.stopUpdatingLocation()
	}
}
