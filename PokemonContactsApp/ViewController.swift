//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    struct contacts {
        var name: String
        var phoneNumber: String
    }
    
    var testData: [contacts] = [
        contacts(name: "김민수", phoneNumber: "010-1234-5678"),
        contacts(name: "이서연", phoneNumber: "010-2345-6789"),
        contacts(name: "박지훈", phoneNumber: "010-3456-7890"),
        contacts(name: "최유진", phoneNumber: "010-4567-8901"),
        contacts(name: "정예린", phoneNumber: "010-5678-9012"),
        contacts(name: "한지훈", phoneNumber: "010-6789-0123"),
        contacts(name: "윤아름", phoneNumber: "010-7890-1234"),
        contacts(name: "장도윤", phoneNumber: "010-8901-2345"),
        contacts(name: "오지현", phoneNumber: "010-9012-3456"),
        contacts(name: "배성민", phoneNumber: "010-0123-4567"),
        contacts(name: "서지우", phoneNumber: "010-1111-2222"),
        contacts(name: "강하늘", phoneNumber: "010-2222-3333"),
        contacts(name: "조예린", phoneNumber: "010-3333-4444"),
        contacts(name: "문태윤", phoneNumber: "010-4444-5555"),
        contacts(name: "김수빈", phoneNumber: "010-5555-6666")
    ]
    
    
    // 타이틀 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 추가 버튼
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        
        return button
    }()
    
    // 연락처를 표시할 테이블 뷰
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }


    private func configureUI() {
        view.backgroundColor = .white
        
        [titleLabel, button, tableView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc private func buttonTapped() {
        print("버튼 클릭")
        self.navigationController?.pushViewController(ContactsViewController(), animated: true)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        cell.configureUI()
        let contact = testData[indexPath.row]
        cell.nameLabel.text = contact.name
        cell.phoneNumberLabel.text = contact.phoneNumber
        return cell
    }
    
    
}
