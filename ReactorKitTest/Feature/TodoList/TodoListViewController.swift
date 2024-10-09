//
//  ViewController.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/2/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources

class TodoListViewController: UIViewController, View {
  
  typealias Reactor = TodoListViewReactor
  
  // MARK: - View
  private lazy var tableView: UITableView = {
    let view = UITableView()
    view.rowHeight = 50
    view.register(
      TodoTableViewCell.self,
      forCellReuseIdentifier: TodoTableViewCell.identifier
    )
    return view
  }()
  
  private lazy var addButton: UIBarButtonItem = {
    let view = UIBarButtonItem(systemItem: .add)
    return view
  }()
  
  var disposeBag: DisposeBag = DisposeBag()
  
  init(reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    view.backgroundColor = .white
    
    addSubviews()
    configureConstraints()
    setupNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.reactor?.action.onNext(.viewDidLoad)
  }
  
  // MARK: - addSubviews()
  private func addSubviews() {
    self.view.addSubview(tableView)
  }
  
  // MARK: - configureConstraints()
  private func configureConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  func bind(reactor: TodoListViewReactor) {
    reactor.state
      .map { $0.isPresentingDetailView }
      .distinctUntilChanged()
      .filter { $0 }
      .bind(onNext: { [weak self] _ in
        let todo = self?.reactor?.currentState.selectedTodo
        let reactor = TodoDetailViewReactor(todo: todo ?? Todo())
        let vc = TodoDetailViewController(reactor: reactor)
        
        self?.navigationController?
          .pushViewController(vc, animated: true)
      })
      .disposed(by: disposeBag)
    
    
    reactor.state
      .map { $0.todos }
      .distinctUntilChanged()
      .bind(to: tableView.rx.items) { tableView, row, todo in
        
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: TodoTableViewCell.identifier
        ) as? TodoTableViewCell else { return UITableViewCell() }
        
        cell.setupData(todo)
        
        return cell
      }
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .map { TodoListViewReactor.Action.addButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .map { Reactor.Action.todoItemTapped($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    self.navigationItem.rightBarButtonItem = addButton
  }
}


extension TodoListViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
