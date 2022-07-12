//
//  RootViewController.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/7/5.
//

import UIKit

class RootViewController: UIViewController {
    
    var mainPageViewController = MainPageViewController()
    
    var index = 1
    
    //MARK: - properties
    private let titleLabel:UILabel = {
        let label = UILabel()
        let title = NSMutableAttributedString(string: "Red",attributes:    [NSAttributedString.Key.foregroundColor:UIColor.white.cgColor])
        title.append(NSMutableAttributedString(string: "So", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red.cgColor]))
        label.attributedText = title
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    let segment = CustomSegmentControl(setTitle: ["Rangers", "Elastic", "Dynamo"])
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configPageViewController()
    }
    
    //MARK: - selectors
    
    
    //MARK: - Helpers
    func configureUI(){
        navigationItem.titleView = titleLabel
        segment.backgroundColor = .clear
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configPageViewController(){
        addChild(mainPageViewController)
        mainPageViewController.page = index
        mainPageViewController.passIndexdelegate = self
        view.addSubview(mainPageViewController.view)
        mainPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

extension RootViewController:PassIndexDelegate{
    func passindex(index: Int) {
        self.index = index
        segment.buttonAction(sender: segment.buttons[index])
    }
}

protocol PassIndexDelegate:AnyObject{
    func passindex(index:Int)
}


enum Catalog:Int, CaseIterable {
    case rengers = 0, elastic, dynamo
    
    var title:String{
        switch self {
        case .rengers:
            return "rangers"
        case .elastic:
            return "elastic"
        case .dynamo:
            return "dynamo"
        }
    }
}
