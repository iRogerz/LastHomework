//
//  CustomSegmentControl.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/7/5.
//

import UIKit

class CustomSegmentControl: UIControl {
    
    //MARK: - LifeCycle
    required init(setTitle:[String]){
        super.init(frame: .zero)
        self.buttonTitles = setTitle
        createButton()
        configStackView()
        configSelectorView()
    }
    
    //MARK: - properties
    private var buttonTitles = [String]()
    var buttons = [UIButton]()
    private var selectorView:UIView = .init()
    
    var textColor:UIColor = .lightGray
    var selectTextColor:UIColor = .white
    var selectViewColor:UIColor = .white
    
    var pageIndex = 1
    
    
    func didTapButton(_ button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else { return }
        self.pageIndex = index
        sendActions(for: .valueChanged)
    }
    //MARK: - selectors
    @objc func buttonAction(sender: UIButton){
        for button in buttons {
            button.setTitleColor(textColor, for: .normal)
        }
        sender.setTitleColor(selectTextColor, for: .normal)
        selectorView.snp.remakeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(sender)
            make.centerX.equalTo(sender)
            make.bottom.equalTo(sender).offset(-2)
        }
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
        pageIndex = sender.tag
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - configView
extension CustomSegmentControl{
    
    private func configStackView(){
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.alignment = .fill
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.spacing = 30
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func configSelectorView(){
        selectorView = UIView()
        selectorView.backgroundColor = selectViewColor
        addSubview(selectorView)
        selectorView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(buttons[pageIndex].snp.width)
            make.leading.equalTo(buttons[pageIndex].snp.leading)
            make.bottom.equalTo(buttons[pageIndex].snp.bottom).offset(-2)
        }
    }
    
    private func createButton(){
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for (index, buttonTitle) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.addTarget(self, action: #selector(buttonAction(sender: )), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.tag = index
            buttons.append(button)
        }
        buttons[1].setTitleColor(selectTextColor, for: .normal)
    }
}
