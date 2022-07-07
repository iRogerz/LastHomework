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
    var pages = [UIViewController]()
    
    //MARK: - properties

    
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
        setupList()
//        guard let listVC = setupListViewController(page: page) else {return}
//        setViewControllers([listVC], direction: .forward, animated: false)
    }
    
    //MARK: - selectors
    @objc func handleSegmant(_ sender:UISegmentedControl){
        //        guard let team = Catalog(rawValue: sender.selectedSegmentIndex) else {return}
        //
        //        tableView.reloadData()
    }
    
    //MARK: - Helpers
    private func setupList(){
        let rangerVC = ListViewController()
        let elasticVC = ListViewController()
        let dynamoVC = ListViewController()
        rangerVC.page = 0
        elasticVC.page = 1
        dynamoVC.page = 2
        rangerVC.setupAPI()
        elasticVC.setupAPI()
        dynamoVC.setupAPI()
        pages = [rangerVC, elasticVC, dynamoVC]
        setViewControllers([pages[page]], direction: .forward, animated: false)
    }
    
//    private func setupListViewController(page:Int) -> UIViewController? {
//        guard Catalog.allCases.indices.contains(page) else {
//            return nil
//        }
//        return pages[page]
//    }

    func configureUI(){
        
    }
    
}

extension MainPageViewController:UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//       return setupListViewController(page: page - 1)
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = currentIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        return setupListViewController(page: page + 1)
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = currentIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}
