//
//  Router.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import UIKit

class Router: NSObject {
    
    static let shared = Router()
    private var mainNavigation:BaseNavVC?
    var appWindow: UIWindow? {
        var window: UIWindow?
        window = SceneDelegate.shared?.window
        #if DEBUG
        if window.isNil {
            fatalError("UIWindow is not found!")
        }
        #endif
        return window
    }
    
    private override init()
    {
        //Private Init for Singleton Pattern
    }
    
    func initialiseLaunchVC() {
        mainNavigation = BaseNavVC(rootViewController: LaunchVC.instantiate(fromAppStoryboard: .Onboarding))
        SceneDelegate.shared?.window?.rootViewController = mainNavigation
        appWindow?.makeKeyAndVisible()
    }
    
    func goToLanguagePrefSelectionVC(fromVC: BaseVC) {
        if fromVC.navigationController.isNotNil
        {
            fromVC.navigationController!.pushViewController(LanguageSelectionVC.instantiate(fromAppStoryboard: .Onboarding), animated: true)
        }
    }
    
    func goToTutorialVC(fromVC: BaseVC) {
        if fromVC.navigationController.isNotNil {
            fromVC.navigationController!.pushViewController(TutorialVC.instantiate(fromAppStoryboard: .Onboarding), animated: true)
        }
    }
}
