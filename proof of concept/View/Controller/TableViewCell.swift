//
//  TableViewCell.swift
//  proof of concept
//
//  Created by Akshay Dibe on 17/01/20.
//  Copyright © 2020 Akshay Dibe. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    
    let profileImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
       return img
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor =  UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  UIColor.darkGray
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descLabel)
        let marginGuide = contentView.layoutMarginsGuide

        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:60).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:marginGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:marginGuide.trailingAnchor).isActive = true


        
        descLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor,constant: 5).isActive = true
        descLabel.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant: 10).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor,constant: -10).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true



     }
    
    
     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}
