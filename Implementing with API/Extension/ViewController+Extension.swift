//
//  ViewController+Extension.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/08.
//

import UIKit.UIViewController

extension UIViewController {
    ///  뷰컨트롤러 이름 가져오기
    var identifier: String {
        return String(describing: self)
    }
}
