//
//  TutorialPage1VC.swift
//  Kudu
//
//  Created by Admin on 13/06/22.
//

import UIKit

class TutorialPage1VC: BaseVC {
    @IBOutlet private weak var skipButton: UIButton!
    var selectedLanguage: LanguageSelectionView.LanguageButtons = .english

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedLanguage == .arabic {
            skipButton.setTitle("تخطي", for: .normal)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: Constants.NotificationObservers.endTutorialFlow.rawValue), object: nil)
    }
}
