//
//  UITableView+Extensions.swift
//  DLibSampler
//
//  Created by ELLIOTT, Dylan on 9/3/18.
//  Copyright © 2018 Dylan Elliott. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reusableCell(withIdentifier identifier: String = "Cell", style: UITableViewCellStyle = .default) -> UITableViewCell {
        
        return self.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: style, reuseIdentifier: identifier)
    }
}
