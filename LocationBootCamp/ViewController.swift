//
//  ViewController.swift
//  LocationBootCamp
//
//  Created by Rijo Samuel on 01/01/22.
//

import UIKit
import MapKit

final class ViewController: UIViewController {
	
	private let map: MKMapView = {
		
		let map = MKMapView()
		return map
	}()
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		view.addSubview(map)
		
		LocationManager.shared.getUserLocation { [weak self] location in
			
			DispatchQueue.main.async {
				
				guard let this = self else { return }
				
				this.addMapPin(with: location)
			}
		}
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		map.frame = view.bounds
	}
	
	private func addMapPin(with location: CLLocation) {
		
		let pin = MKPointAnnotation()
		pin.coordinate = location.coordinate
		let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
		self.map.setRegion(MKCoordinateRegion(center: location.coordinate, span: span), animated: true)
		self.map.addAnnotation(pin)
		
		LocationManager.shared.resolveLocationName(with: location) { [weak self] locationName in
			self?.title = locationName
		}
	}
}
