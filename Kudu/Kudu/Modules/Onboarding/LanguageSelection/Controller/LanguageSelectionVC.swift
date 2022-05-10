//
//  LanguageSelectionVC.swift
//  Kudu
//
//  Created by Admin on 10/05/22.
//

import UIKit
import LanguageManager_iOS

class LanguageSelectionVC:BaseVC
{
    @IBOutlet private var baseView: LanguageSelectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView()
        handleActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
    }
    
    private func handleActions()
    {
        baseView.handleViewActions = {
            [weak self] in
            guard let vc = self else { return }
            switch $0
            {
            case .continueButtonPressed:
                if vc.baseView.currentLanguage == .arabic
                {
                    LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
                }
                Router.shared.goToTutorialVC(fromVC: vc)
            case .arabicPressed:
                LanguageManager.shared.setLanguage(language: .ar, for: nil, viewControllerFactory: nil, animation: nil)
            case .englishPressed:
                LanguageManager.shared.setLanguage(language: .en, for: nil, viewControllerFactory: nil, animation: nil)
            }
        }
    }
}
