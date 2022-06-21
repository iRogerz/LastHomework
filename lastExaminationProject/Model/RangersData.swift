//
//  RangersData.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/21.
//

import Foundation

struct RangersData{
    var results:[Results]
}

struct Results{
    var id:String
    var type:String
    var name:String
    var position:String
    var expertise:[String]
    var avator:URL
    var url:URL
}

