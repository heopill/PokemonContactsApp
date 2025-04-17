//
//  ContactsTableViewCell.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let identifier = "ContactsTableViewCell"
    
    let circleImageView = UIImageView()
    let nameLabel = UILabel()
    let phoneNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        circleImageView.layer.cornerRadius = 20
        circleImageView.clipsToBounds = true
//        circleImageView.image = UIImage(systemName: "person.circle.fill")
        circleImageView.contentMode = .scaleAspectFill
        circleImageView.layer.borderColor = UIColor.gray.cgColor
        circleImageView.layer.borderWidth = 1.0
        
        nameLabel.text = "Hello"
        nameLabel.textColor = .black
        
        phoneNumberLabel.text = "010-1234-1234"
        nameLabel.textColor = .black
        
        [circleImageView ,nameLabel, phoneNumberLabel].forEach {
            contentView.addSubview($0)
        }
        
        circleImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(circleImageView.snp.trailing).offset(30)
            make.centerY.equalToSuperview()
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.centerY.equalToSuperview()
        }
    }
}
