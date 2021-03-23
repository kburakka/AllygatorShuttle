//
//  DetailView.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 22.03.2021.
//

import UIKit

class DetailView: UIView {
    private var type: AnnotationType? = .station
    private var address: String? = ""

    private let containerView = UIView(backgroundColor: .clear)

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.height(15)
        imageView.width(15)
        return imageView
    }()
    
    private var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .mavenProMediumMedium
        label.textColor = .coal
        label.numberOfLines = 2
        label.accessibilityIdentifier = "addressLabel"
        return label
    }()
    
    // MARK: - Init
    convenience init(type: AnnotationType?, address: String?) {
        defer {
            self.type = type
            self.address = address
            setImage()
            setAddress()
        }
        self.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    // swiftlint:disable fatal_error unavailable_function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    // swiftlint:enable fatal_error unavailable_function
    
    func commonInit() {
        setupViews()
        setupLayouts()
    }

    func setupViews() {
        containerView.addSubviews([imageView, addressLabel])
        addSubview(containerView)
    }

    func setupLayouts() {
        imageView.edgesToSuperview(excluding: .trailing, insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        addressLabel.edgesToSuperview(excluding: .leading, insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        addressLabel.leadingToTrailing(of: imageView, offset: 10)
        
        containerView.edgesToSuperview()
    }
}

// MARK: - Helper
extension DetailView {
    func setImage() {
        switch type {
        case .vehicle:
            imageView.image = .imgVehicle
        case .dropoff:
            imageView.image = .imgFinish
        case .pickup:
            imageView.image = .imgStart
        case .station:
            imageView.image = .imgStation
        case .none:
            imageView.image = .imgStation
        }
    }
    
    func setAddress() {
        addressLabel.text = address
    }
}
