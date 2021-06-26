//
//  MapViewController.swift
//  myPlaces
//
//  Created by Артем Хребтов on 26.06.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var coctail: Coctail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlacemark()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeVC() {
        dismiss(animated: true)
    }
   
    private func setupPlacemark() {
        guard let location = coctail.ingridients else { return }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            let annotation = MKPointAnnotation()
            annotation.title = self.coctail.name
            annotation.subtitle = self.coctail.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }

}
