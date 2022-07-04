//
//  LanguageSelectionVC.swift
//  Kudu
//
//  Created by Admin on 10/05/22.
//

import UIKit
import LanguageManager_iOS

class LanguageSelectionVC: BaseVC {
    @IBOutlet private weak var baseView: LanguageSelectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView()
        handleActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weak var weakSelf = self.navigationController as? BaseNavVC
        weakSelf?.disableSwipeBackGesture = true
        //LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
    }
    
    private func handleActions() {
        baseView.handleViewActions = { [weak self] in
            guard let vc = self else { return }
            switch $0 {
            case .continueButtonPressed:
//                let selectedLanguage = vc.baseView.currentLanguage == .arabic ? Languages.ar : Languages.en
//                AppUserDefaults.save(value: selectedLanguage.rawValue, forKey: .selectedLanguage)
//                if vc.baseView.currentLanguage == .arabic {
//                    LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
//                }
                Router.shared.goToTutorialVC(fromVC: vc, selectedLanguage: vc.baseView.currentLanguage)
            default:
                break
//            case .arabicPressed:
//                LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
//            case .englishPressed:
//                LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
            }
        }
    }
}
