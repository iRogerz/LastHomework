//
//  Store.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

class Store{
    static let shared = Store()
    
    var rangers = [Results]()
    var elastics = [CResults]()
    var dynamos = [Results]()
    private(set) var stores = [CResults]()
    
    func getData(catalog:Catalog){
        for index in 0..<10{
            CurrentDataService.getCurrentData(by: catalog, by: index) { result in
                switch result{
                case .success(let data):
                    for result in data.results {
                        self.stores.append(result)
                        print(self.stores)
//                        switch result {
//                        case .banner(let banner):
//                            print(banner)
//                        case .employee(let employee):
//                            print(employee)
//                        }
                    }
     
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    private init(){

    }
}
