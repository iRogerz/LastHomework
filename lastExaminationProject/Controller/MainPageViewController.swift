//
//  MainPageViewController.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/7/1.
//

import UIKit

class MainPageViewController: UIPageViewController {
    
    //    var initialPage:Int?
    var page = 1
    //    var pages = [UIViewController]()
    
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
    
    //transtion style改為scroll
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        configureUI()
        guard let listVC = setupListViewController(page: page) else {return}
        setViewControllers([listVC], direction: .forward, animated: false)
    }
    
    //MARK: - selectors
    @objc func handleSegmant(_ sender:UISegmentedControl){
        //        guard let team = Catalog(rawValue: sender.selectedSegmentIndex) else {return}
        //
        //        tableView.reloadData()
    }
    
    //MARK: - Helpers
    
    private func setupListViewController(page:Int) -> UIViewController? {
        guard Catalog.allCases.indices.contains(page) else {
            return nil
        }
        guard let team = Catalog(rawValue: page) else {return nil}
        
        let listVC = ListViewController()
        listVC.setupAPI(team: team)
        listVC.page = page
        return listVC
    }
    
    func configureUI(){
        navigationItem.titleView = titleLabel
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }
    
}
extension MainPageViewController:UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return setupListViewController(page: page - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return setupListViewController(page: page + 1)
    }
}
