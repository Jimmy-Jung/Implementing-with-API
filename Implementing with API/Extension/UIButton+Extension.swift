//
//  UIButton+Extension.swift
//  Tamagotchi
//
//  Created by 정준영 on 2023/08/05.
//

import UIKit

extension UIButton {

    /// 버튼 클릭시 배경색 변화 애니메이션 및 햅틱반응
    /// - Parameters:
    ///   - button: 적용 할 버튼
    ///   - type: ButtonActionType
    func buttonTapEffect() {
        
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseIn ]
        ) {
            self.backgroundColor = .systemBlue
        }
        UIView.transition(
            with: self,
            duration: 0.3,
            options: [.curveEaseOut]
        ) {
            self.backgroundColor = .darkGray
        }
    }
}

