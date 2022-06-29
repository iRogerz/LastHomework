//
//  Store.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

class Store{
//    static let shared = Store()

    var callBackReloadData:(() -> ())?
    
    private let userDefault = UserDefaults.standard
    
    private(set) var rangers = [CResults](){
        didSet{
//            saveData()
        }
    }
    private(set) var elastics = [CResults](){
        didSet{
//            saveData()
        }
    }
    private(set) var dynamos = [CResults](){
        didSet{
//            saveData()
        }
    }
    private(set) var stores = [CResults](){
        didSet{
//            saveData()
        }
    }
    
    //Create a dispatch queue
    let dispatchQueue = DispatchQueue(label: "myQueue", qos: .background)
    //Create a semaphore
    let semaphore = DispatchSemaphore(value: 0)
    
    func getData(catalog:Catalog){
        dispatchQueue.async{
            for index in 0..<10{
                CurrentDataService.getCurrentData(by: catalog, by: index) { result in
                    switch result{
                    case .success(let data):
                        for result in data.results {
                            switch catalog {
                            case .rengers:
                                self.rangers.append(result)
                            case .elastic:
                                self.elastics.append(result)
                            case .dynamo:
                                self.dynamos.append(result)
                            }
//                            self.stores.append(result)
                            
                            self.semaphore.signal()
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                self.semaphore.wait()
            }
            self.callBackReloadData?()
        }
    }
    
    private func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(stores){
            let defaults = userDefault
            defaults.set(encoded, forKey: "storeData")
        }
    }

    private func loadData(){
        if let saveData = userDefault.object(forKey: "storeData")as? Data{
            let decoder = JSONDecoder()
            if let loadData = try? decoder.decode(Array<CResults>.self, from: saveData){
                stores = loadData
            }
        }
    }
    
    init(){
//        loadData()
    }
}
