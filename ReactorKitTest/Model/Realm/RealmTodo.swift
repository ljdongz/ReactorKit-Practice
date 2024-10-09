//
//  RealmTodo.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/7/24.
//

import Foundation
import RealmSwift

final class RealmTodo: Object {
  @Persisted(primaryKey: true) var id: UUID
  @Persisted var title: String
  @Persisted var content: String
  @Persisted var isCompleted: Bool
  
  convenience init(
    id: UUID,
    title: String,
    content: String,
    isCompleted: Bool
  ) {
    self.init()
    self.id = id
    self.title = title
    self.content = content
    self.isCompleted = isCompleted
  }
  
  convenience init(todo: Todo) {
    self.init()
    self.id = todo.id
    self.title = todo.title
    self.content = todo.content
    self.isCompleted = todo.isCompleted
  }
}

extension RealmTodo {
  func toEntity() -> Todo {
    return Todo(
      id: self.id,
      title: self.title,
      content: self.content,
      isCompleted: self.isCompleted
    )
  }
}

