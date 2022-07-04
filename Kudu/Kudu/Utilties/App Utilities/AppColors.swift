//
//  AppColors.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import Foundation
import UIKit

final class AppColors: UIColor {
    
    struct LanguagePrefScreen {
       static var selectedBorder: UIColor { #colorLiteral(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.45) }
       static var unselectedBorder: UIColor { #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 0.34) }
    }
    
    struct LoginScreen {
        static var unselectedButtonBg: UIColor { #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1) }
        static var unselectedButtonTextColor: UIColor { #colorLiteral(red: 0.3568627451, green: 0.3529411765, blue: 0.3529411765, alpha: 0.5) }
        static var selectedBgButtonColor: UIColor { #colorLiteral(red: 0.9607843137, green: 0.6980392157, blue: 0.1058823529, alpha: 1) }
    }
    
    struct SignUpScreen {
        static var termsAndConditionsGrey: UIColor { #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1) }
    }
    
    struct PhoneVerificationScreen {
        static var trackColorGrey: UIColor { #colorLiteral(red: 0.9499530196, green: 0.9499530196, blue: 0.9499530196, alpha: 1) }
        static var progressColorYellow: UIColor { #colorLiteral(red: 0.9732094407, green: 0.7451413274, blue: 0.1295291781, alpha: 1) }
        static var resendButtonColor: UIColor { #colorLiteral(red: 0.9732094407, green: 0.7451413274, blue: 0.1295291781, alpha: 1) }
        static var differentNumLabel: UIColor { #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6) }
    }
    
    static var gray636367: UIColor { #colorLiteral(red: 0.3882352941, green: 0.3882352941, blue: 0.4039215686, alpha: 1) }
    static var kuduThemeBlue: UIColor { #colorLiteral(red: 0.1990443468, green: 0.3514102101, blue: 0.6041271687, alpha: 1) }
}
