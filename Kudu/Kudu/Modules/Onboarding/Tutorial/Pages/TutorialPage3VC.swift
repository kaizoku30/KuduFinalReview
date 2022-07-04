//
//  TutorialPage3VC.swift
//  Kudu
//
//  Created by Admin on 13/06/22.
//

import UIKit

class TutorialPage3VC: BaseVC {
    @IBOutlet private weak var getStartedButton: UIButton!
    @IBOutlet private weak var baseView: TutorialPage3View!
    var selectedLanguage: LanguageSelectionView.LanguageButtons = .english
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseView.checkForOverlap(inVC: self)
    }
}
