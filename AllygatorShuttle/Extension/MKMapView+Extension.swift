//
//  MKMapView+Extension.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 19.03.2021.
//

import MapKit

extension MKMapView {
    func addAnnotationIfNotExist(_ annotation: MKAnnotation) {
        if view(for: annotation) == nil {
            addAnnotation(annotation)
        }
    }
    
    func removeAllAnnotations() {
        removeAnnotations(annotations)
    }
}
