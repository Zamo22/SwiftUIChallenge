//
//  MapView.swift
//  BucketList
//
//  Created by Zaheer Moola on 2021/07/27.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool

    var annotations: [MKPointAnnotation]
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }

        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? MKPointAnnotation else { return }

            parent.selectedPlace = placemark
            parent.showingPlaceDetails = true
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Placemark"

                // attempt to find a cell we can recycle
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

                if annotationView == nil {
                    // we didn't find one; make a new one
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)

                    // allow this to show pop up information
                    annotationView?.canShowCallout = true

                    // attach an information button to the view
                    annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                } else {
                    // we have a view to reuse, so give it the new annotation
                    annotationView?.annotation = annotation
                }

                // whether it's a new view or a recycled one, send it back
                return annotationView
        }
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
    }
}
