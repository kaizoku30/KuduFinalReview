//
//  LanguageSelectionView.swift
//  Kudu
//
//  Created by Admin on 10/05/22.
//

import UIKit

class LanguageSelectionView: UIView {
    
    @IBOutlet private weak var englishView: UIView!
    @IBOutlet private weak var arabicView: UIView!
    @IBOutlet private weak var continueButton: AppButton!
    @IBOutlet private var arabicLabels: [UILabel]!
    @IBOutlet private var englishLabels: [UILabel]!

    var handleViewActions: ((ViewActions) -> Void)?
    var currentLanguage: LanguageButtons = .arabic
    
    enum ViewActions {
        case continueButtonPressed
        case englishPressed
        case arabicPressed
    }
    
    enum LanguageButtons {
        case arabic
        case english
    }
    
    enum ButtonState {
        case selected
        case unselected
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arabicLabels.forEach({ $0.adjustsFontSizeToFitWidth = true })
        englishLabels.forEach({ $0.adjustsFontSizeToFitWidth = true })
    }
    
    func setupView() {
        continueButton.handleBtnTap = {
            [weak self] in
            guard let view = self else { return }
            view.handleViewActions?(.continueButtonPressed)
        }
        englishView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(englishViewTapped)))
        arabicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arabicViewTapped)))
    }
    
    @objc private func englishViewTapped() {
        currentLanguage = .english
        changeButtonState(.english, .selected)
        changeButtonState(.arabic, .unselected)
        handleViewActions?(.englishPressed)
    }
    
    @objc private func arabicViewTapped() {
        currentLanguage = .arabic
        changeButtonState(.arabic, .selected)
        changeButtonState(.english, .unselected)
        handleViewActions?(.arabicPressed)
    }
    
    private func changeButtonState(_ button: LanguageButtons, _ state: ButtonState) {
        switch button {
        case .arabic:
            switch state {
            case .selected:
                arabicView.borderWidth = 0
                arabicView.backgroundColor = AppColors.gray636367
                arabicLabels.forEach({ $0.textColor = .white })
            case .unselected:
                arabicView.borderWidth = 1
                arabicView.backgroundColor = AppColors.white
                arabicLabels.forEach({ $0.textColor = .black })
            }
        case .english:
            switch state {
            case .selected:
                englishView.borderWidth = 0
                englishView.backgroundColor = AppColors.gray636367
                englishLabels.forEach({ $0.textColor = .white })
            case .unselected:
                englishView.borderWidth = 1
                englishView.backgroundColor = AppColors.white
                englishLabels.forEach({ $0.textColor = .black })
            }
        }
    }
}
