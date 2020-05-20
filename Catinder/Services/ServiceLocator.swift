//
//  ServiceLocator.swift
//  Catinder
//
//  Created by HexaHack on 17.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

protocol  ServiceLocating {
    func getService<T>() -> T?
}

final class ServiceLocator {
    
    
    
    private lazy var services: [String : Any] = [:]
    
    private func typeName(_ some: Any) -> String {
        return (some is  Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    private func addService<T>(service: T) {
        let key = typeName(T.self)
        services[key] = service
    }
    func getService<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }
    public static let shared = ServiceLocator()
    
    private init() {
        let apiService = APIService()
        let userService = UserService()
        let imageService = ImagesService(apiService: apiService, userService: userService)
        addService(service: apiService as APIServiceProtocol)
        addService(service: userService as UserServiceProtocol)
        addService(service: imageService as ImagesServiceProtocol)
    }
    
}

