//
//  ViewController.swift
//  snapkit-demo-swift
//
//  Created by 조중윤 on 2022/04/12.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private let biggerWindow: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let middleWindow: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private let smallerWindow: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    private let layoutChangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("change red window's auto layout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(biggerWindow)
        self.biggerWindow.addSubview(middleWindow)
        self.middleWindow.addSubview(smallerWindow)
        self.view.addSubview(layoutChangeButton)
        
        biggerWindow.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        middleWindow.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.bottom.equalToSuperview().inset(100)
        }
        
        smallerWindow.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(10)
        }
        
        layoutChangeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.view.snp_bottomMargin).inset(20)
        }
        
        layoutChangeButton.addAction(UIAction(handler: { [unowned self] touched in
            UIView.animate(withDuration: 5, delay: 0.5, options: .transitionCurlUp) {
                self.smallerWindow.snp.remakeConstraints { make in
                    make.bottom.equalTo(self.middleWindow.snp_bottomMargin)
                    make.size.equalToSuperview().dividedBy(20)
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
                // to do
            }
        }), for: .touchUpInside)
        
    }
    
}

