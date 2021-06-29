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
    var coctail = Coctail()
    let annotationIdentifire = "annotationIdentifire"
    
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

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifire)
        as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifire)
            annotationView?.canShowCallout = true
        }
        
        if let imageData = coctail.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
           
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
    
    
}
