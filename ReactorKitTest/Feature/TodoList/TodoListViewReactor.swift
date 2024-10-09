//
//  TodoReactor.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/5/24.
//

import Foundation
import ReactorKit

final class TodoListViewReactor: Reactor {
  
  enum Action {
    case viewDidLoad
    case addButtonTapped
    case todoItemTapped(IndexPath)
    case removeButtonTapped(Todo)
  }
  
  enum Mutation {
    case fetchTodos([Todo])
    case showDetailView(isPresent: Bool, isEditMode: Bool)
    case removeTodo(Todo)
    case setSelectedTodo(Todo?)
  }
  
  struct State {
    var todos: [Todo] = []
    var isEditMode: Bool = false
    var isPresentingDetailView: Bool = false
    var selectedTodo: Todo?
  }
  
  var initialState: State = .init()
  
  private let todoRepository: TodoRepository
  
  init() {
    self.todoRepository = DIContainer.shared.resolve(
      TodoRepository.self
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return Observable<Mutation>.create { [weak self] observer in
        // TodoRepository에서 삭제 작업 수행
        let todos = self?.todoRepository.fetchTodos() ?? []
    
        // 삭제 작업 완료 후 onNext 호출
        observer.onNext(.fetchTodos(todos))
        observer.onCompleted()
        return Disposables.create()
      }
    case .addButtonTapped:
      return Observable.concat([
        .just(.setSelectedTodo(nil)),
        .just(.showDetailView(isPresent: true, isEditMode: false)),
        .just(.showDetailView(isPresent: false, isEditMode: false))
      ])
    case .todoItemTapped(let todo):
      return Observable.concat([
        .just(.setSelectedTodo(self.currentState.todos[todo.row])),
        .just(.showDetailView(isPresent: true, isEditMode: true)),
        .just(.showDetailView(isPresent: false, isEditMode: true))
      ])
    case .removeButtonTapped(let todo):
      return Observable<Mutation>.create { [weak self] observer in
        // TodoRepository에서 삭제 작업 수행
        self?.todoRepository.deleteTodo(todo)
        
        // 삭제 작업 완료 후 onNext 호출
        observer.onNext(.removeTodo(todo))
        observer.onCompleted()
        return Disposables.create()
      }
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .fetchTodos(let todos):
      newState.todos = todos
    case let .showDetailView(isPresent, isEditMode):
      newState.isEditMode = isEditMode
      newState.isPresentingDetailView = isPresent
    case .removeTodo(let todo):
      newState.todos.removeAll(where: { $0.id == todo.id })
    case .setSelectedTodo(let todo):
      newState.selectedTodo = todo
    }
    return newState
  }
}
