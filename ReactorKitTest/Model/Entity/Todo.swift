//
//  Todo.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/5/24.
//

import Foundation

struct Todo: Equatable {
  var id: UUID = UUID()
  var title: String = ""
  var content: String = ""
  var isCompleted: Bool = false
}
