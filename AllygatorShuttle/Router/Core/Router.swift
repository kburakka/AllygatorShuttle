//
//  Router.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import UIKit

protocol RouterProtocol: AnyObject {
    func open(_ viewController: UIViewController, transition: Transition)
    func close()
}

class Router: RouterProtocol {
    
    weak var viewController: UIViewController?
    var openTransition: Transition?

    func open(_ viewController: UIViewController, transition: Transition) {
        transition.viewController = self.viewController
        transition.open(viewController)
    }

    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}
