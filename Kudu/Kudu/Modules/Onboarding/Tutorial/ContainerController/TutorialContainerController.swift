//
//  TutorialContainerController.swift
//  Kudu
//
//  Created by Admin on 13/06/22.
//

import UIKit
import LanguageManager_iOS
import liquid_swipe

class TutorialContainerController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    private var viewControllers: [UIViewController] = []
    
    var selectedLanguage: LanguageSelectionView.LanguageButtons = .english
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupControllers()
            NotificationCenter.default.addObserver(self, selector: #selector(moveToLogin), name: NSNotification.Name.init(rawValue: Constants.NotificationObservers.endTutorialFlow.rawValue), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func moveToLogin() {
        self.view.isHidden = true
        let selectedLanguage = self.selectedLanguage
        let language = selectedLanguage == .arabic ? AppUserDefaults.Language.ar : AppUserDefaults.Language.en
        AppUserDefaults.save(value: language.rawValue, forKey: .selectedLanguage)
        if selectedLanguage == .arabic {
            LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
        } else {
            LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
        }
        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Onboarding)
        loginVC.viewModel = LoginVM(selectedLang: self.selectedLanguage, _delegate: loginVC)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    private func setupControllers() {
        if viewControllers.isEmpty {
            let firstPageVC = TutorialPage1VC.instantiate(fromAppStoryboard: .Onboarding)
            firstPageVC.selectedLanguage = self.selectedLanguage
           // firstPageVC.delegate = self
            let secondPageVC = TutorialPage2VC.instantiate(fromAppStoryboard: .Onboarding)
            secondPageVC.selectedLanguage = self.selectedLanguage
           // secondPageVC.delegate = self
            let thirdPageVC = TutorialPage3VC.instantiate(fromAppStoryboard: .Onboarding)
            thirdPageVC.selectedLanguage = self.selectedLanguage
           // thirdPageVC.delegate = self
            let controllers: [UIViewController] = [firstPageVC, secondPageVC, thirdPageVC]
            viewControllers = controllers
            datasource = self
        }
    }
    
    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        viewControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }
    
}

//extension TutorialContainerController: TutorialContainerDelegate {
//    func goToLogin() {
//        let loginVC = LoginVC.instantiate(fromAppStoryboard: .Onboarding)
//        loginVC.viewModel = LoginVM(selectedLang: self.selectedLanguage, _delegate: loginVC)
//        self.navigationController?.pushViewController(loginVC, animated: true)
//    }
//}
