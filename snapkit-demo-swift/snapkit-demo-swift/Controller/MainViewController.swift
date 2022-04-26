//
//  ViewController.swift
//  snapkit-demo-swift
//
//  Created by 조중윤 on 2022/04/12.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    //MARK: - Properties
    
    /// The outer view containing the middleView
    private let biggerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    /// Inner view of the biggerView. It initially contains the smaller view
    private let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    
    /// Inner view of the middleView. Is going to change its layout and parent view in this project
    private let smallerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    /// change layouts of the smaller view
    private let layoutChangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemCyan
        button.setTitle("Switch red view's auto layout", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    
    /// change parent view of the smaller view
    private let parentChangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Switch parent of red view", for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        return button
    }()
    
    private var smallerViewLayoutChanged: Bool = false
    private var smallerViewParentChanged: Bool = false
    
    //MARK: - Callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(biggerView)
        self.biggerView.addSubview(middleView)
        self.middleView.addSubview(smallerView)
        self.view.addSubview(layoutChangeButton)
        self.view.addSubview(parentChangeButton)
        
        self.setBiggerViewLayout()
        self.setMiddleViewLayout()
        self.setSmallerViewLayout()
        self.setLayoutChangeButtonLayout()
        self.configureParentChangeButton()
        
        self.setLayoutChangeButtonAction()
        self.setParentChangeButtonAction()
    }
    
    //MARK: - Methods
    private func setBiggerViewLayout() {
        biggerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setMiddleViewLayout() {
        middleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(300)
            make.bottom.equalToSuperview().inset(300)
        }
    }
    
    private func setSmallerViewLayout() {
        smallerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(10)
        }
    }
    
    private func setLayoutChangeButtonLayout() {
        layoutChangeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottom).inset(20)
            make.width.equalToSuperview().dividedBy(1.2)
            make.height.equalToSuperview().dividedBy(10)
        }
    }
    
    private func setLayoutChangeButtonAction() {
        layoutChangeButton.addAction(UIAction(handler: { [unowned self] _ in
            self.remakeSmallerViewLayout()
        }), for: .touchUpInside)
    }
    
    private func configureParentChangeButton() {
        parentChangeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(layoutChangeButton.snp.top).inset(-20)
            make.width.equalToSuperview().dividedBy(1.2)
            make.height.equalToSuperview().dividedBy(10)
        }
    }
    
    private func setParentChangeButtonAction() {
        parentChangeButton.addAction(UIAction(handler: { [unowned self] _ in
            self.resetSmallerViewParent()
        }), for: .touchUpInside)
    }
    
    private func remakeSmallerViewLayout() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCurlUp) {
            if self.smallerViewLayoutChanged {
                /// place the smaller view to center of the parent view
                /// notice you use `remakeContraints` method
                self.smallerView.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.size.equalToSuperview().dividedBy(10)
                }
                
            } else {
                /// palce the smaller view to the upper-left of the parent view
                self.smallerView.snp.remakeConstraints { make in
                    make.top.equalToSuperview().inset(20)
                    make.leading.equalToSuperview().inset(20)
                    make.size.equalToSuperview().dividedBy(20)
                }
            }
            
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.smallerViewLayoutChanged = !self.smallerViewLayoutChanged
            print("Changed auto layout successfully")
        }
    }
    
    private func resetSmallerViewParent() {
        self.smallerView.removeFromSuperview()
        
        /// switch parent of smaller view between the middleView and biggerView
        if self.smallerViewParentChanged {
            middleView.addSubview(smallerView)
        } else {
            biggerView.addSubview(smallerView)
        }
        
        /// notice that you can re-use the same auto layout code here again.
        /// That is because SnapKit does not refer to the parent view explicitly, making it possible to automatically adapt auto layout to a new parent view
        self.setSmallerViewLayout()
        self.smallerViewParentChanged = !self.smallerViewParentChanged
        self.view.layoutIfNeeded()
        print("Changed parent of smaller view successfully")
    }
    
}

