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
    lazy var sortedContactsTableData = contactsTableData.sorted { $0.name < $1.name }
    
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
                    print("name: \(name), phoneNumber: \(phoneNumber), imageUrl: \(imageUrl)")
                    contactsTableData.append(ContactsModel(name: name, phoneNumber: phoneNumber, imageUrl: imageUrl))
                }
            }
        } catch {
            print("데이터 읽기 실패")
        }
        tableView.reloadData()
    }
    
    // 저장된 데이터 선택 삭제
    func deleteData(name: String) {
        // 삭제할 데이터를 찾기 위한 fetch request 생성
        let fetchRequest = Contacts.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            // fetch request 실행
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            // 결과 처리
            for data in result as [NSManagedObject] {
                // 삭제
                // CRUD 의 D.
                self.container.viewContext.delete(data)
                print("삭제된 데이터: \(data)")
            }
            
            // 변경 사항 저장
            try self.container.viewContext.save()
            print("데이터 삭제 완료")
            
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
        tableView.reloadData()
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
        return sortedContactsTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.identifier, for: indexPath) as? ContactsTableViewCell else { return UITableViewCell() }
        
        cell.configureUI()
        
        let contact = sortedContactsTableData[indexPath.row]
        
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
}

