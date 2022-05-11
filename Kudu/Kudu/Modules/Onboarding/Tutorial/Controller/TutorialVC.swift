//
//  TutorialVC.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import UIKit

class TutorialVC: BaseVC {
    @IBOutlet var baseView: TutorialView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView()
        handleActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.navigationController as? UIGestureRecognizerDelegate
    }
    
    private func handleActions() {
        baseView.handleViewActions = {
            if $0 == .continueButtonPressed {
                debugPrint("Move To Sign In")
            }
        }
    }
}
