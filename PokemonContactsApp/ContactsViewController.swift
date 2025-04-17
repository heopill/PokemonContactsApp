//
//  ContactsViewController.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit
import CoreData

class ContactsViewController: UIViewController {
    
    private let circleImageView = UIImageView()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        configureUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {

        view.backgroundColor = .white
        self.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(naviButtonTapped))
        
        circleImageView.layer.cornerRadius = 75
        circleImageView.clipsToBounds = true
        circleImageView.contentMode = .scaleAspectFill
        circleImageView.layer.borderColor = UIColor.gray.cgColor
        circleImageView.layer.borderWidth = 2.0
        
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.cornerRadius = 3
        
        phoneNumberTextField.layer.borderColor = UIColor.gray.cgColor
        phoneNumberTextField.layer.borderWidth = 1.0
        phoneNumberTextField.layer.cornerRadius = 3
        
        [circleImageView, button, nameTextField, phoneNumberTextField].forEach {
            view.addSubview($0)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(circleImageView.snp.bottom).offset(10)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(button.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        
    }
    
    @objc private func buttonTapped() {
        print("랜덤 이미지 생성 버튼 클릭")
    }
    
    @objc private func naviButtonTapped() {
        print("네비게이션 버튼 클릭")
        self.navigationController?.popViewController(animated: true)
    }
}
