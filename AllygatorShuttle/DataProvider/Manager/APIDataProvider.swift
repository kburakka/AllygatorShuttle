//
//  APIDataProvider.swift
//  AllygatorShuttle
//
//  Created by Burak Kaya on 18.03.2021.
//

public struct APIDataProvider: DataProviderProtocol {
    
    // Singleton
    public static let shared = APIDataProvider()
    
    public init() {}
}
