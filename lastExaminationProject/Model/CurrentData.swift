//
//  CurrentData.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

struct CurrentData:Decodable{
    var results:[CResults]
}

struct Employee:Decodable{
    var id:String
    var type:String
    var name:String
    var position:String
    var expertise:[String]
    var avatar:String
}

struct Banner:Decodable{
    var type:String
    var url:URL
}

enum CResults:Decodable{
    case employee(Employee)
    case banner(Banner)
    
    enum CodingKeys:CodingKey{
        case id, type, name, position, expertise, avatar, url
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(String.self, forKey: CodingKeys.type)
        if type == "banner"{
            // create banner
            let url = try values.decode(URL.self, forKey: CodingKeys.url)
            let banner = Banner(type: "banner", url: url)
            self = .banner(banner)
//            print("create banner")
            return
        }
        if type == "employee" {
            let id = try values.decode(String.self, forKey: CodingKeys.id)
            let name = try values.decode(String.self, forKey: CodingKeys.name)
            let position = try values.decode(String.self, forKey: CodingKeys.position)
            let expertise = try values.decode([String].self, forKey: CodingKeys.expertise)
            let avatar = try values.decode(String.self, forKey: CodingKeys.avatar)
            let employee = Employee(id: id, type: type, name: name, position: position, expertise: expertise, avatar: avatar)
            self = .employee(employee)
//            print("create emplopyee")
            return
        }
        print("unknown")
        throw Error.unknownType
        
    }
    
    enum Error: Swift.Error {
        case unknownType
    }
}

struct Results:Decodable{
    var id:String?
    var type:String
    var name:String?
    var position:String?
    var expertise:[String]?
    var avator:URL?
    var url:URL?

    enum CodingKeys:CodingKey{
        case id, type, name, position, expertise, avator, url
    }

}


//func resultToCResult(_ result: Results) -> CResults? {
//    if result.type == "banner"{
//        
//    }
//}
