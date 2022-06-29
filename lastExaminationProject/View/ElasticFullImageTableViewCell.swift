//
//  ElasticFullImageTableViewCell.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/20.
//

import UIKit

class ElasticFullImageTableViewCell: UITableViewCell {

    static let identifier = "elasticFullImageTableViewCellIdentifier"
    
    //MARK: - properties
    var image:UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "testImage")
        return imageView
    }()
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure
    func configureUI(){
        addSubview(image)
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
}
