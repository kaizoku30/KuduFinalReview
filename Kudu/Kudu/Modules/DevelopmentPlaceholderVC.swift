//
//  DevelopmentPlaceholderVC.swift
//  Kudu
//
//  Created by Admin on 28/06/22.
//

import UIKit
import Gifu
import FBSDKLoginKit
import GoogleSignIn

class DevelopmentPlaceholderVC: BaseVC {
    @IBOutlet private weak var gifView: GIFView!
    @IBOutlet private weak var logoutBtn: AppButton!
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        logoutBtn.startBtnLoader(color: .white)
        
        WebServices.OnboardingEndPoints.logout(success: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.goToLoginScreen()
        }, failure: { [weak self] in
            SKToast.show(withMessage: $0.msg)
            self?.logoutBtn.stopBtnLoader()
        })
    }
    
    private func goToLoginScreen() {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        GIDSignIn.sharedInstance.signOut()
        AppUserDefaults.removeValue(forKey: .loginResponse)
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.contains(where: {
                $0.isKind(of: LoginVC.self)
            }) {
                NotificationCenter.postNotificationForObservers(.resetLoginState)
                self.popToSpecificViewController(kindOf: LoginVC.self)
                return
            }
        }
        
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Onboarding)
        let currentLanguage: LanguageSelectionView.LanguageButtons = AppUserDefaults.selectedLanguage() == .ar ? .arabic : .english
        loginVC.viewModel = LoginVM(selectedLang: currentLanguage, _delegate: loginVC, _expiryError: "")
        self.push(vc: loginVC)
        self.logoutBtn.stopBtnLoader()
    }
    
    override func viewDidLoad() {
        gifView.backgroundColor = .clear
        gifView.animate(withGIFNamed: "kuduTriangleGIF")
    }
}
