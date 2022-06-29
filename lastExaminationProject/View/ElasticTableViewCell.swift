//
//  ElasticTableViewCell.swift
//  lastExaminationProject
//
//  Created by 曾子庭 on 2022/6/20.
//

import UIKit

class ElasticTableViewCell: UITableViewCell {

    static let identifier = "elasticTableViewCellIdentifier"
    
    //MARK: - properties
    var headShotImage:UIImageView = {
//        let imageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up.circle.fill"))
        let imageView = UIImageView()
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.red.cgColor
        //研究一下如何用成圓形的
//        imageView.layer.masksToBounds = false
//        imageView.layer.cornerRadius = imageView.frame.size.height/2
        imageView.layer.cornerRadius = 120/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var nameLabel:UILabel = {
        let label = UILabel()
//        label.text = "asdfasdf"
        label.textColor = .white
        return label
    }()
    var positionLabel:UILabel = {
        let label = UILabel()
//        label.text = "asdfasdf"
        label.textColor = .white
        return label
    }()
    var contentLabel:UILabel = {
        let label = UILabel()
//        label.text = "asdfasdf"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configure
    func configureUI(){
        
        addSubview(headShotImage)
        headShotImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(22)
            make.width.height.equalTo(120)
        }
        
        let labelStackView = UIStackView(arrangedSubviews:  [
            nameLabel, positionLabel, contentLabel
        ])
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        addSubview(labelStackView)
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(headShotImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-46)
        }
    }

}
