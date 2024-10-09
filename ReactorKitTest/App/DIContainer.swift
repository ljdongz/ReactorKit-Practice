//
//  DIContainer.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/4/24.
//

import Foundation

final class DIContainer {
  static let shared = DIContainer()
  
  private var dependencies: [String: Any] = [:]
  
  init() {
    self.registerDependencies()
  }
  
  private func register<T>(_ type: T.Type, dependency: T) {
    let key = String(describing: type)
    dependencies[key] = dependency
  }
  
  func resolve<T>(_ type: T.Type) -> T {
      let key = String(describing: type)
      return dependencies[key] as! T
  }
  
  private func registerDependencies() {
    self.register(
      TodoRepository.self,
      dependency: TodoRepositoryImpl() // Stub 객체
    )
  }
}
