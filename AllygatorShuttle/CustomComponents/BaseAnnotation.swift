//
//  BaseAnnotation.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import MapKit

class BaseAnnotation: MKPointAnnotation {
    var image: UIImage?
    var annotationType: AnnotationType?

    init(image: UIImage?, annotationType: AnnotationType) {
        self.image = image?.resize(targetSize: CGSize(width: 40, height: 40))
        self.annotationType = annotationType
    }
}
