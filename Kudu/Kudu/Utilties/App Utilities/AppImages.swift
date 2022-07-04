//
//  AppImages.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import UIKit

final class AppImages {
    struct MainImages {
        static var kuduLogoWithText: UIImage { #imageLiteral(resourceName: "kuduLogoWithText") }
        static var blackCross: UIImage { #imageLiteral(resourceName: "blackCross") }
        static var clearCross: UIImage { #imageLiteral(resourceName: "clearCross") }
    }
    
    struct LanguagePrefScreen {
       static var selected: UIImage { #imageLiteral(resourceName: "selectedGreenCircle") }
       static var unSelected: UIImage { #imageLiteral(resourceName: "unselectedCircle") }
    }
    
    struct LoginScreen {
        static var successCircle: UIImage { #imageLiteral(resourceName: "k_login_greenCircleCheck") }
        static var failureCircle: UIImage { #imageLiteral(resourceName: "k_login_redCircleCross") }
    }
}
