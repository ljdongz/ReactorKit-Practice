//
//  TodoDetailViewController.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/6/24.
//

import UIKit
import SnapKit
import ReactorKit


class TodoDetailViewController: UIViewController, View {
  
  private lazy var titleTextField: UITextField = {
    let view = UITextField()
    view.placeholder = "Title"
    return view
  }()
  
  private lazy var contentTextView: UITextView = {
    let view = UITextView()
    return view
  }()
  
  private lazy var saveButton: UIBarButtonItem = {
    let view = UIBarButtonItem(systemItem: .done)
    return view
  }()
  
  typealias Reactor = TodoDetailViewReactor
  
  var disposeBag = DisposeBag()
  
  init(reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
    
    self.setupData(reactor.initialState.todo)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    // Do any additional setup after loading the view.
    
    addSubviews()
    configureConstraints()
    setupNavigationBar()
  }
  
  // MARK: - addSubviews()
  
  private func addSubviews() {
    view.addSubview(titleTextField)
    view.addSubview(contentTextView)
  }
  
  // MARK: - configureConstraints()
  
  private func configureConstraints() {
    titleTextField.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.height.equalTo(40)
    }
    
    contentTextView.snp.makeConstraints { make in
      make.top.equalTo(titleTextField.snp.bottom).offset(10)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      
    }
  }
  
  func bind(reactor: TodoDetailViewReactor) {
    saveButton.rx.tap
      .map { Reactor.Action.saveButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isPresentingAlert }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        self?.showAlert("할 일 저장", "저장하시겠습니까?")
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isDismissing }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    titleTextField.rx.text.orEmpty
      .map { Reactor.Action.isEdittingTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    contentTextView.rx.text.orEmpty
      .map { Reactor.Action.isEdittingContent($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func setupData(_ todo: Todo?) {
    titleTextField.text = todo?.title
    contentTextView.text = todo?.content
  }
  
  private func setupNavigationBar() {
    self.navigationItem.rightBarButtonItem = saveButton
  }
  
  private func showAlert(_ title: String, _ message: String) {
    let alertViewController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    
    let ok = UIAlertAction(title: "저장", style: .default) { _ in
      guard let reactor = self.reactor else { return }
      reactor.action.onNext(.okButtonTapped(
        reactor.currentState.todo
      ))
    }
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    
    alertViewController.addAction(ok)
    alertViewController.addAction(cancel)
    
    self.present(alertViewController, animated: true)
  }
}
