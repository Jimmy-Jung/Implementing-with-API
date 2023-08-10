//
//  UIButton+Extension.swift
//  Tamagotchi
//
//  Created by 정준영 on 2023/08/05.
//

import UIKit

extension UIButton {
    enum Target {
        case tint
        case background
    }
    /// 버튼 클릭시 배경색 변화 애니메이션 및 햅틱반응
    /// - Parameters:
    ///   - button: 적용 할 버튼
    ///   - type: ButtonActionType
    func buttonTapEffect(target: Target, defaults: UIColor, highlighted: UIColor) {
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseIn ]
        ) {
            switch target {
            case .tint:
                var config = UIButton.Configuration.plain()
                config.baseForegroundColor = highlighted
                config.image = self.imageView?.image
                self.configuration = config
            case .background:  self.backgroundColor = highlighted
            }
        }
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseOut]
        ) {
            switch target {
            case .tint:
                var config = UIButton.Configuration.plain()
                config.baseForegroundColor = defaults
                config.image = self.imageView?.image
                self.configuration = config
            case .background: self.backgroundColor = defaults
            }
        }
    }
    
    /// 버튼 클릭시 배경색 변화 애니메이션 및 햅틱반응
    /// - Parameters:
    ///   - button: 적용 할 버튼
    ///   - type: ButtonActionType
    func buttonTapEffect(defaultColor: UIColor, highlightedColor: UIColor) {
        
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseIn ]
        ) {
            self.backgroundColor = highlightedColor
        }
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseOut]
        ) {
            self.backgroundColor = defaultColor
        }
    }
}

