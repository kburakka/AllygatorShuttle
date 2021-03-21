//
//  RideFinishViewController.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 20.03.2021.
//

import UIKit

final class PopupViewController: BaseViewController<PopupViewModel> {
    
    // MARK: - UI
    private lazy var containerView: UIView = {
        return UIView(backgroundColor: .calcite,
                      cornerRadius: 11.0)
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: .imgDone)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = .mavenProMediumXXLarge
        label.textColor = .coal
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 6
        button.titleLabel?.font = .mavenProMediumLarge
        button.backgroundColor = .coal
        button.titleLabel?.textColor = .calcite
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        return UIStackView(arrangedSubviews: [titleLabel,
                                              closeButton],
                           axis: .vertical,
                           spacing: 15,
                           alignment: .center,
                           distribution: .fill)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.83)
    }
    
    override func setupViews() {
        super.setupViews()
        view.accessibilityIdentifier = "PopupViewController"
        containerView.addSubviews([stackView])
        view.addSubviews([containerView, imageView])
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        imageView.height(120)
        imageView.width(120)
        imageView.centerX(to: containerView)
        imageView.bottomToTop(of: stackView, offset: -8)
        
        closeButton.height(44.0)
        closeButton.width(155.0)
        
        stackView.edgesToSuperview(insets: UIEdgeInsets(top: 58.0,
                                                        left: 20.0,
                                                        bottom: 20.0,
                                                        right: 20.0))
        containerView.edgesToSuperview(excluding: [.top, .bottom],
                                       insets: UIEdgeInsets(top: 53.0,
                                                            left: 20.0,
                                                            bottom: 20.0,
                                                            right: 20.0))
        containerView.centerXToSuperview()
        containerView.centerYToSuperview()
        
    }
}

// MARK: - Action
@objc
private extension PopupViewController {
    func closeAction() {
        viewModel.closeCompletion?()
    }
}
