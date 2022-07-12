//
//  ListViewController.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/20.
//

import UIKit

class ListViewController: UIViewController {
    
    var store = Store()
    var stores = [CResults]()
    var page:Int?
    var APICurrentPage = 1
    private let APILimitPage = 9
    
    //MARK: - properties
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAPI), for: .valueChanged)
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
        
    }
    
    func setupAPI(){
        guard let team = Catalog(rawValue: page!) else {return}
        store.removeAll()
        store.getData(catalog: team, page: 0)
        store.callBackReloadData = {
            DispatchQueue.main.async {
                self.stores = self.store.stores
                self.tableView.reloadData()
            }
        }
    }
    
    func updateAPI(APIpage:Int){
        guard let team = Catalog(rawValue: page!) else {return}
        store.getData(catalog: team, page: APIpage)
        store.callBackReloadData = {
            DispatchQueue.main.async {
                self.stores = self.store.stores
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - delegate
    func delegate(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - selectors
    @objc func refreshAPI(){
        setupAPI()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [self] in
            refreshControl.endRefreshing()
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
    }
    
}

//MARK: - tableView extension
extension ListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentData = stores[indexPath.row]
        switch currentData{
        case .employee(let employee):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticTableViewCell.identifier, for: indexPath) as? ElasticTableViewCell else { return UITableViewCell()}
            
            //這裡應該會有api呼叫順序錯亂的問題?
            let avatarString = employee.avatar.absoluteString
            cell.headShotImage.load(urlString: avatarString)
            cell.nameLabel.text = employee.name
            cell.positionLabel.text = employee.position
            let stringRepertation = employee.expertise.joined(separator: ",")
            cell.contentLabel.text = stringRepertation
            
            return cell
        case .banner(let banner):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ElasticFullImageTableViewCell.identifier, for: indexPath) as? ElasticFullImageTableViewCell else { return UITableViewCell()}
            
            let avatarString = banner.url.absoluteString
            cell.image.load(urlString: avatarString)
            
            return cell
        }
    }
}

extension ListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentData = stores[indexPath.row]
        switch currentData{
        case .employee(_):
            return 150
        case .banner(_):
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == stores.count-1{
            if APICurrentPage <= APILimitPage {
                updateAPI(APIpage: APICurrentPage)
                APICurrentPage += 1
            }
        }
    }
    
    
}
