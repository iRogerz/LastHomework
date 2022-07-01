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
    
    private(set) var stores = [CResults](){
        didSet{
            //            saveData()
        }
    }
    
    func getData(catalog:Catalog, page:Int){
        CurrentDataService.getCurrentData(by: catalog, by: page) { result in
            switch result{
            case .success(let data):
                for result in data.results {
                    self.stores.append(result)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.callBackReloadData?()
        }
    }
    
    func removeAll(){
        stores.removeAll()
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
