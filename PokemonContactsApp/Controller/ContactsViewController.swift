//
//  ContactsViewController.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit
import CoreData
import Alamofire

class ContactsViewController: UIViewController {
    
    private let circleImageView = UIImageView()
    var container: NSPersistentContainer!
    var imageUrl = ""
    var isModify = false // 수정 여부 확인
    var modifyContact: ContactsModel? // ViewController 에서 데이터 전달
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        configureUI()
        
        // CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // CoreData 데이터 저장하기
    func createData(name: String, phoneNumber: String, imageUrl: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: Contacts.className, in: self.container.viewContext) else { return }
        let newContacts = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newContacts.setValue(name, forKey: Contacts.Key.name)
        newContacts.setValue(phoneNumber, forKey: Contacts.Key.phoneNumber)
        newContacts.setValue(imageUrl, forKey: Contacts.Key.imageUrl)
        
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }
    
    // Alamofire를 이용해서 데이터 받기
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    // Alamorife를 이용해서 포켓몬 API 에게 데이터 요청하기
    private func fetchPokemonData() {
        let randomNumber = Int.random(in: 1...1000)
        print(randomNumber)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)") else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (result: Result<PokemonResult, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                print("id: \(result.id), name: \(result.name), weight: \(result.weight), height: \(result.height)")
                
                guard let imageUrl = URL(string: result.sprites.front_default) else { return }
                
                self.imageUrl = result.sprites.front_default
                
                // 이미지 뷰에 받아온 이미지 넣기
                AF.request(imageUrl).responseData { response in
                    if let data = response.data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.circleImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("데이터 로드 실패 : \(error)")
            }
        }
        
    }
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        if isModify == false {
            self.title = "연락처 추가"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(naviButtonTapped))
            
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(naviButtonTapped))
            
            // 옵셔널 값 처리
            guard let modifyContact = modifyContact else { return }
            
            self.title = modifyContact.name
            nameTextField.text = modifyContact.name
            phoneNumberTextField.text = modifyContact.phoneNumber
            
            AF.request(modifyContact.imageUrl).responseData { response in
                if let data = response.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.circleImageView.image = image
                    }
                }
            }
            
        }
        
        
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
        fetchPokemonData()
    }
    
    @objc private func naviButtonTapped() {
        print("네비게이션 버튼 클릭")
        createData(name: nameTextField.text ?? "", phoneNumber: phoneNumberTextField.text ?? "", imageUrl: "\(self.imageUrl)")
        self.navigationController?.popViewController(animated: true)
        
    }
}
