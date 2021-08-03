//
//  MapView.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/27.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let annotation: MKPointAnnotation

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {

        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
        }
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion( center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 4000)!, longitudinalMeters: CLLocationDistance(exactly: 4000)!)
        mapView.setRegion(region, animated: true)
        mapView.delegate = context.coordinator
        return mapView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {}
}
