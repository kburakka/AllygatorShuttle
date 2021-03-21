//
//  BaseAnnotationView.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 21.03.2021.
//

import UIKit
import MapKit

class BaseAnnotationView: MKAnnotationView {
    var imageView: UIImageView?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }

    func updateImge(image: UIImage?) {
        guard let image = image else { return }
        
        if let imageView = imageView {
            self.imageView?.image = image
            frame = imageView.frame
        } else {
            let newImageView = UIImageView(image: image)
            imageView = newImageView
            addSubview(newImageView)
        }
    }
}
