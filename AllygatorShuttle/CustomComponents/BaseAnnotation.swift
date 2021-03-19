//
//  BaseAnnotation.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import MapKit

class BaseAnnotation: MKPointAnnotation {
    var image: UIImage?
    
    init(image: UIImage?) {
        self.image = image?.resize(targetSize: CGSize(width: 50, height: 50))
    }
    
}
