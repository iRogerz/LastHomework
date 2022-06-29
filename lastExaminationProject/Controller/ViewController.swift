//
//  ViewController.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/20.
//

import UIKit

class ViewController: UIViewController {
    
    var store = Store()
    var stores = [CResults]()
    
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
        
        //預設
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
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateAPI), for: .valueChanged)
        return refreshControl
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
        setupAPI()
        updateAPI()
    }
    
    func setupAPI(){
        store.getData(catalog: .rengers)
        store.getData(catalog: .elastic)
        store.getData(catalog: .dynamo)
    }
    @objc func updateAPI(){
        guard let team = Catalog(rawValue: segmentControl.selectedSegmentIndex) else {return}
        store.getData(catalog: team)
        store.callBackReloadData = {
            DispatchQueue.main.async {
                switch team {
                case .rengers:
                    self.stores = self.store.rangers
                case .elastic:
                    self.stores = self.store.elastics
                case .dynamo:
                    self.stores = self.store.dynamos
                }
                    
                self.tableView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [self] in
            refreshControl.endRefreshing()
        }
    }
    //MARK: - delegate
    func delegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - selectors
    @objc func handleSegmant(_ sender:UISegmentedControl){
        guard let team = Catalog(rawValue: sender.selectedSegmentIndex) else {return}
        switch team {
        case .rengers:
            stores = store.rangers
        case .elastic:
            stores = store.elastics
        case .dynamo:
            stores = store.dynamos
        }
        tableView.reloadData()
    }
    
    //MARK: - Helpers
    func configureUI(){
        //        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        view.addSubview(segmentControl)
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        segmentControl.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
        }
        
    }
}

//MARK: - tableView extension
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return store.stores.count
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let currentData = store.stores[indexPath.row]
        let currentData = stores[indexPath.row]
        switch currentData{
        case .employee(let employee):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticTableViewCell.identifier, for: indexPath) as? ElasticTableViewCell else { return UITableViewCell()}
            
            //這裡應該會有api呼叫順序錯亂的問題
            cell.headShotImage.load(url: employee.avatar)
            cell.nameLabel.text = employee.name
            cell.positionLabel.text = employee.position
            let stringRepertation = employee.expertise.joined(separator: ",")
            cell.contentLabel.text = stringRepertation
            return cell
        case .banner(let banner):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticFullImageTableViewCell.identifier, for: indexPath) as? ElasticFullImageTableViewCell else { return UITableViewCell()}
            cell.image.load(url: banner.url)
            return cell
        }
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let currentData = store.stores[indexPath.row]
        let currentData = stores[indexPath.row]
        switch currentData{
        case .employee(_):
            return 150
        case .banner(_):
            return 200
        }
    }
}

