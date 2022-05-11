//
//  TutorialView.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import UIKit

class TutorialView: UIView {
    @IBOutlet private weak var foodDeliveryLabel: UILabel!
    @IBOutlet private weak var greatTasteLabel: UILabel!
    @IBOutlet private weak var continueButton: AppButton!
    
    var handleViewActions: ((ViewActions) -> Void)?
    
    enum ViewActions {
        case continueButtonPressed
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodDeliveryLabel.text = LS.TutorialVC.getFoodDelivery
        greatTasteLabel.text = LS.TutorialVC.greatTasteLabel
        continueButton.setTitleForAllMode(title: LS.TutorialVC.continueButtonTitle)
    }
    
    func setupView() {
        continueButton.handleBtnTap = {
            [weak self] in
            guard let view = self else { return }
            view.handleViewActions?(.continueButtonPressed)
        }
    }
}
