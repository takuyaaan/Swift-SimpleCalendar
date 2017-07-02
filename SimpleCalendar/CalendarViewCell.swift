//
//  CalendarViewCell.swift
//  SimpleCalendar
//
//  Created by Takuyaaan on 2017/06/28.
//  Copyright © 2017年 Takuyaaan. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    var dateLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        dateLabel.textAlignment = .center
        self.addSubview(dateLabel!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
}
