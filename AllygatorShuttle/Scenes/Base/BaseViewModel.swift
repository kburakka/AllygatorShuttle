//
//  BaseViewModel.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

import Foundation

protocol BaseViewModelDataSource: AnyObject {}

protocol BaseViewModelEventSource: AnyObject {
    var showActivityIndicatorView: VoidClosure? { get set }
    var hideActivityIndicatorView: VoidClosure? { get set }
    
    var showLoading: VoidClosure? { get set }
    var hideLoading: VoidClosure? { get set }
}

protocol BaseViewModelProtocol: BaseViewModelDataSource, BaseViewModelEventSource {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

class BaseViewModel<R: Router>: BaseViewModelProtocol {
    
    var showActivityIndicatorView: VoidClosure?
    var hideActivityIndicatorView: VoidClosure?
    
    var showLoading: VoidClosure?
    var hideLoading: VoidClosure?
    
    let router: R
    let dataProvider: DataProviderProtocol
    
    init(router: R, dataProvider: DataProviderProtocol = APIDataProvider.shared) {
        self.router = router
        self.dataProvider = dataProvider
    }
    
    func viewDidLoad() {}
    
    func viewDidAppear() {}
    
    func viewWillAppear() {}
    
    func viewWillDisappear() {}
    
    func viewDidDisappear() {}
}
