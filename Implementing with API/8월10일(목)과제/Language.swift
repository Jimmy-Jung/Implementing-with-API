//
//  Language.swift
//  Implementing with API
//
//  Created by 정준영 on 2023/08/10.
//

import Foundation

enum Language: String, CaseIterable {
    case ko
    case en
    case ja
    case zh_CN
    case zh_TW
    case vi
    case id
    case th
    case de
    case ru
    case es
    case it
    case fr
    
    var localizedString: String {
        get{
            switch self {
            case .ko:
                return "한국어"
            case .en:
                return "영어"
            case .ja:
                return "일본어"
            case .zh_CN:
                return "중국어 간체"
            case .zh_TW:
                return "중국어 번체"
            case .vi:
                return "베트남어"
            case .id:
                return "인도네시아어"
            case .th:
                return "태국어"
            case .de:
                return "독일어"
            case .ru:
                return "러시아어"
            case .es:
                return "스페인어"
            case .it:
                return "이탈리아어"
            case .fr:
                return "프랑스어"
            }
        }
    }
}
