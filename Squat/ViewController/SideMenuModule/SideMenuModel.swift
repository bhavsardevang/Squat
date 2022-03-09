//
//  SideMenuModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import Localize_Swift
enum SideMenuTitle {
    case home,besnu,terviVidhi,personDocument,besnuList,terviList,personCardList,deleteData,logOut
        func selectedString() -> String {
            switch self {
            case .home:
                return "Home".localized()
            case .besnu:
                return "Rasam Kriya(BESNU)".localized()
            case .terviVidhi:
                return "Tervi Vidhi".localized()
            case .personDocument:
                return "Person Document".localized()
            case .besnuList:
                return "Besnu List".localized()
            case .terviList:
                return "Tervi List".localized()
            case .personCardList:
                return "Person Card List".localized()
            case .deleteData:
                return "Delete All Data".localized()
            case .logOut:
                return "Logout".localized()
            default:
                return "Home".localized()
            }
        }
}

