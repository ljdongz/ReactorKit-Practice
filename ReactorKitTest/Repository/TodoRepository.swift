//
//  TodoRepository.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/5/24.
//

import Foundation
import RealmSwift

protocol TodoRepository: AnyObject {
  func createTodo(_ todo: Todo)
  func fetchTodos() -> [Todo]
  func updateTodo(_ todo: Todo)
  func deleteTodo(_ todo: Todo)
}

final class TodoRepositoryImpl: TodoRepository {
  private let realm = try! Realm()
  
  func createTodo(_ todo: Todo) {
    print("createTodo: \(todo)")
    
    let todo = RealmTodo(todo: todo)
    try! realm.write {
        realm.add(todo)
    }
  }
  
  func fetchTodos() -> [Todo] {
    print("fetchTodos")
    
    let todos = realm.objects(RealmTodo.self)
    return todos.map { $0.toEntity() }
    
  }
  
  func updateTodo(_ todo: Todo) {
    print("updateTodo: \(todo)")
    
    let todo = RealmTodo(todo: todo)
    try! realm.write {
      realm.add(todo, update: .modified)
    }
  }
  
  func deleteTodo(_ todo: Todo) {
    print("deleteTodo: \(todo)")
    
    let todo = RealmTodo(todo: todo)
    try! realm.write {
        realm.delete(todo)
    }
  }
}

// MARK: - Stub
final class StubTodoRepository: TodoRepository {
  
  private var todos: [Todo] = [
    Todo(id: UUID(), title: "1번 메모", content: "테스트", isCompleted: false),
    Todo(id: UUID(), title: "2번 메모", content: "테스트", isCompleted: false),
    Todo(id: UUID(), title: "3번 메모", content: "테스트", isCompleted: false)
  ]
  
  func createTodo(_ todo: Todo) {
    self.todos.append(todo)
  }
  
  func fetchTodos() -> [Todo] {
    return self.todos
  }
  
  func updateTodo(_ todo: Todo) {
    if let index = self.todos
      .firstIndex(where: { $0.id == todo.id }) {
      self.todos[index] = todo
    }
  }
  
  func deleteTodo(_ todo: Todo) {
    if let index = self.todos
      .firstIndex(where: { $0.id == todo.id }) {
      self.todos.remove(at: index)
    }
  }
  
}
