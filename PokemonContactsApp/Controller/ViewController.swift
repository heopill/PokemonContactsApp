//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit
import SnapKit
import CoreData
import Alamofire

class ViewController: UIViewController {

    var container: NSPersistentContainer!
    var contactsTableData: [ContactsModel] = []
    
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
        
        // CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        readAllData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func sortData() {
        let sortedContactsTableData = contactsTableData.sorted { $0.name < $1.name }
        contactsTableData = sortedContactsTableData
    }
    
    // 저장된 데이터 읽어오기
    private func readAllData() {
        contactsTableData = []
        do {
            let contactsData = try self.container.viewContext.fetch(Contacts.fetchRequest())
            
            for data in contactsData as [NSManagedObject] {
                if let name = data.value(forKey: Contacts.Key.name) as? String,
                   let phoneNumber = data.value(forKey: Contacts.Key.phoneNumber) as? String,
                   let imageUrl = data.value(forKey: Contacts.Key.imageUrl) as? String{
                    contactsTableData.append(ContactsModel(name: name, phoneNumber: phoneNumber, imageUrl: imageUrl))
                }
            }
            
            sortData()
        } catch {
            print("데이터 읽기 실패")
        }
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
    // 테이블 뷰의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // 테이블 뷰에 표시할 행의 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsTableData.count
    }
    
    // 테이블 뷰 셀 부분
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        
        cell.configureUI()
        
        let contact = contactsTableData[indexPath.row]
        
        cell.nameLabel.text = contact.name
        cell.phoneNumberLabel.text = contact.phoneNumber
        
        AF.request(contact.imageUrl).responseData { response in
            if let data = response.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.circleImageView.image = image
                }
            }
        }
        
        return cell
    }
    
    // 테이블 뷰 클릭 시 이벤트 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modifyVC = ContactsViewController()
        modifyVC.isModify = true // 수정이면 isModify의 값을 true로 변경
        
        // 정보를 넘겨주기 프로퍼티로 정보를 가지고 있어야 한다.
        // 옵셔널로 가지고 있어야 한다. 수정이 될수도 있기 때문에 ex) 값이 있으면 수정, 없으면 추가
        let contact = contactsTableData[indexPath.row]
        modifyVC.modifyContact = contact

        navigationController?.pushViewController(modifyVC, animated: true)
    }
    
}

