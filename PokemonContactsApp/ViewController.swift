//
//  ViewController.swift
//  PokemonContactsApp
//
//  Created by 허성필 on 4/17/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.blue, for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchDown)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        [titleLabel, button].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(80)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }

}

