//
//  CurrentData.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

struct CurrentData:Codable{
    var results:[CResults]
}

struct Employee:Codable{
    var id:String
    var type:String
    var name:String
    var position:String
    var expertise:[String]
    var avatar:URL
}

struct Banner:Codable{
    var type:String
    var url:URL
}

enum CResults:Codable{
    case employee(Employee)
    case banner(Banner)

    enum CodingKeys:Codable, CodingKey{
        case id, type, name, position, expertise, avatar, url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: CodingKeys.type)
        if type == "banner"{
            // create banner
            let url = try container.decode(URL.self, forKey: CodingKeys.url)
            let banner = Banner(type: "banner", url: url)
            self = .banner(banner)
            return
        }
        if type == "employee" {
            let id = try container.decode(String.self, forKey: CodingKeys.id)
            let name = try container.decode(String.self, forKey: CodingKeys.name)
            let position = try container.decode(String.self, forKey: CodingKeys.position)
            let expertise = try container.decode([String].self, forKey: CodingKeys.expertise)
            let avatar = try container.decode(URL.self, forKey: CodingKeys.avatar)
            let employee = Employee(id: id, type: type, name: name, position: position, expertise: expertise, avatar: avatar)
            self = .employee(employee)
            return
        }
        print("unknown")
        throw Error.unknownType
    }
    
    //encode
    func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .employee(let employee):
            try container.encode(employee.type, forKey: CodingKeys.type)
            try container.encode(employee.id, forKey: CodingKeys.id)
            try container.encode(employee.name, forKey: CodingKeys.name)
            try container.encode(employee.position, forKey: CodingKeys.position)
            try container.encode(employee.expertise, forKey: CodingKeys.expertise)
            try container.encode(employee.avatar, forKey: CodingKeys.avatar)
        case .banner(let banner):
            try container.encode(banner.type, forKey: CodingKeys.type)
            try container.encode(banner.url, forKey: CodingKeys.url)
        }
    }
    
    enum Error:Codable, Swift.Error {
        case unknownType
    }
}

struct Results:Codable{
    var id:String?
    var type:String
    var name:String?
    var position:String?
    var expertise:[String]?
    var avator:URL?
    var url:URL?

}

//
//func resultToCResult(_ result: Results) -> CResults? {
//    if result.type == "banner"{
//    }
//}
