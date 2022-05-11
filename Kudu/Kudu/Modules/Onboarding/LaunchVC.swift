//
//  LaunchVC.swift
//  Kudu
//
//  Created by Admin on 05/05/22.
//

import UIKit

class LaunchVC: BaseVC {
    @IBOutlet weak var welcomeBackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        delayAndGoToNextVC()
    }
    
    private func delayAndGoToNextVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.handleFlow()
        })
    }
    
    private func handleFlow() {
        if AppUserDefaults.value(forKey: .selectedLanguage).isNotNil {
            Router.shared.goToTutorialVC(fromVC: self)
        } else {
            Router.shared.goToLanguagePrefSelectionVC(fromVC: self)
        }
    }
}
