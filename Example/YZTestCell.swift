//
//  YZTestCell.swift
//  BatourTool
//
//  Created by iOS_Dev5 on 2017/2/16.
//  Copyright © 2017年 GRSource. All rights reserved.
//

import UIKit

class YZTestCell: UITableViewCell {

    var button = UIButton()
    var btnAction: ((UIButton)->())?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button.frame = CGRect(x: self.contentView.frame.width-70, y: 20, width: 60, height: 40)
        contentView.addSubview(button)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func click(_ sender: UIButton) {
        if btnAction != nil {
            btnAction!(sender)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
