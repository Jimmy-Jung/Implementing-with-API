//
//  TableViewCell+Extension.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/09.
//

import UIKit.UITableViewCell

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
