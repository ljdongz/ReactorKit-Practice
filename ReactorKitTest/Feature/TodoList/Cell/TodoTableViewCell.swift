//
//  TodoTableViewCell.swift
//  ReactorKitTest
//
//  Created by 이정동 on 10/6/24.
//

import UIKit
import SnapKit

class TodoTableViewCell: UITableViewCell {
  
  static let identifier: String = "TodoTableViewCell"
  
  private lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = 5
    view.alignment = .leading
    view.distribution = .fillEqually
    return view
  }()
  
  private lazy var title: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 16)
    view.textColor = .black
    return view
  }()
  
  private lazy var content: UILabel = {
    let view = UILabel()
    view.font = .systemFont(ofSize: 14)
    view.textColor = .gray
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    addSubviews()
    configureConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - addSubviews()
  
  private func addSubviews() {
    self.addSubview(stackView)
    [title, content].forEach(stackView.addArrangedSubview)
  }
  
  // MARK: - configureConstraints()
  
  private func configureConstraints() {
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(5)
    }
  }
  
  func setupData(_ todo: Todo) {
    self.title.text = todo.title
    self.content.text = todo.content
  }
}
