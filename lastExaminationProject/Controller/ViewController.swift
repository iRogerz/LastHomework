//
//  ViewController.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/20.
//

import UIKit

class ViewController: UIViewController {

//    var store = Store()
    
    //MARK: - properties
    private let titleLabel:UILabel = {
        let label = UILabel()
        let title = NSMutableAttributedString(string: "Red",attributes:    [NSAttributedString.Key.foregroundColor:UIColor.white.cgColor])
        title.append(NSMutableAttributedString(string: "So", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red.cgColor]))
        label.attributedText = title
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let segmentControl:UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Rangers", "Elastic", "Dyname"])
        segmentControl.selectedSegmentIndex = 1
        segmentControl.selectedSegmentTintColor = .clear
        //ios13之後tintcolor無效,backgroundColor clear還是會有預設灰色背景...好難改
        //        segmentControl.backgroundColor = .clear
//        segmentControl.layer.borderColor = UIColor.red.cgColor
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        segmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        segmentControl.addTarget(self, action: #selector(handleSegmant), for: .valueChanged)
        return segmentControl
    }()
    
    
    private let tableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.register(ElasticTableViewCell.self, forCellReuseIdentifier: ElasticTableViewCell.identifier)
        tableView.register(ElasticFullImageTableViewCell.self, forCellReuseIdentifier: ElasticFullImageTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        delegate()
        Store.shared.getData(catalog: .elastic)
        
    }
    
    //MARK: - delegate
    func delegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - selectors
    @objc func handleSegmant(_ sender:UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
//        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        view.addSubview(segmentControl)
        view.addSubview(tableView)
        segmentControl.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
        }
    }
    enum Segment{
        case Rangers
        case Elastic
        case Dyname
    }
}

//MARK: - tableView extension
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //到時候用enum
        switch indexPath.row{
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticFullImageTableViewCell.identifier, for: indexPath) as? ElasticFullImageTableViewCell else { return UITableViewCell()}
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticTableViewCell.identifier, for: indexPath) as? ElasticTableViewCell else { return UITableViewCell()}
            return cell
        }
            
    }
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}


