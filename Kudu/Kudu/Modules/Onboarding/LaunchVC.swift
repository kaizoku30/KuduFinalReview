//
//  LaunchVC.swift
//  Kudu
//
//  Created by Admin on 05/05/22.
//

import UIKit
import LanguageManager_iOS

class LaunchVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        debugPrint(gifView.gifLoopDuration)
//        gifView.animate(withGIFNamed: "kuduTriangleGIF")
        delayAndGoToNextVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func delayAndGoToNextVC() {
        if AppUserDefaults.value(forKey: .selectedLanguage) as? String ?? "" == Languages.en.rawValue {
            LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
        } else if AppUserDefaults.value(forKey: .selectedLanguage) as? String ?? "" == Languages.ar.rawValue {
            LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { [weak self] in
            self?.handleFlow()
        })
    }
    
    private func handleFlow() {
        weak var weakSelf = self
      //  self.navigationController?.pushViewController(PhoneVerificationVC.instantiate(fromAppStoryboard: .Onboarding), animated: true)
        
        if AppUserDefaults.value(forKey: .loginResponse).isNotNil {
            let devVC = DevelopmentPlaceholderVC.instantiate(fromAppStoryboard: .Onboarding)
            self.push(vc: devVC)
        } else if AppUserDefaults.value(forKey: .selectedLanguage).isNotNil {
            Router.shared.goToLoginVC(fromVC: weakSelf)
        } else {
            Router.shared.goToLanguagePrefSelectionVC(fromVC: weakSelf)
        }
    }
}
