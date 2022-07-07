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
    private var buttons = [UIButton]()
    private var selectorView:UIView = .init()
    
    var textColor:UIColor = .lightGray
    var selectTextColor:UIColor = .white
    var selectViewColor:UIColor = .white
    
    var index = 1

    //MARK: - selectors
    @objc func buttonAction(sender: UIButton){
        selectorView.snp.remakeConstraints { make in
            make.height.equalTo(2)
            make.width.equalTo(sender)
            make.centerX.equalTo(sender)
            make.bottom.equalTo(sender).offset(-2)
        }
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
        sender.setTitleColor(selectTextColor, for: .normal)
    }
    
    func didTapButton(_ button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else { return }
        self.index = index
        sendActions(for: .valueChanged)
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
            make.width.equalTo(buttons[index].snp.width)
            make.leading.equalTo(buttons[index].snp.leading)
            make.bottom.equalTo(buttons[index].snp.bottom).offset(-2)
        }
    }
    
    private func createButton(){
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.addTarget(self, action: #selector(buttonAction(sender: )), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[1].setTitleColor(selectTextColor, for: .normal)
    }
}
