//
//  TodoDetailViewReactor.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/7/24.
//

import Foundation
import ReactorKit

final class TodoDetailViewReactor: Reactor {
  enum Action {
    case saveButtonTapped
    case okButtonTapped(Todo)
    case isEdittingTitle(String)
    case isEdittingContent(String)
  }
  
  enum Mutation {
    case showAlert(Bool)
    case dismiss
    case updateTitle(String)
    case updateContent(String)
  }
  
  struct State {
    var todo: Todo
    var isPresentingAlert: Bool = false
    var isDismissing: Bool = false
  }
  
  private(set) var initialState: State
  
  private let todoRepository: TodoRepository
  
  init(todo: Todo) {
    initialState = State(todo: todo)
    self.todoRepository = DIContainer.shared.resolve(TodoRepository.self)
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .saveButtonTapped:
      Observable.concat([
        .just(.showAlert(true)),
        .just(.showAlert(false))
      ])
    case .okButtonTapped(let todo):
      Observable<Mutation>.create { [weak self] observer in
        // TodoRepository에서 업데이트 작업 진행
        self?.todoRepository.updateTodo(todo)
        
        // 작업 완료 후 onNext 호출
        observer.onNext(.dismiss)
        observer.onCompleted()
        return Disposables.create()
      }
    case .isEdittingTitle(let str):
        .just(.updateTitle(str))
    case .isEdittingContent(let str):
        .just(.updateContent(str))
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .showAlert(let bool):
      newState.isPresentingAlert = bool
    case .dismiss:
      newState.isDismissing = true
    case .updateTitle(let title):
      newState.todo.title = title
    case .updateContent(let content):
      newState.todo.content = content
    }
    return newState
  }
}
