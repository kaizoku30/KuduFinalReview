//
//  LanguageSelectionView.swift
//  Kudu
//
//  Created by Admin on 10/05/22.
//

import UIKit

class LanguageSelectionView: UIView {
    
    @IBOutlet weak var arabicSubtitle: UILabel!
    @IBOutlet weak var arabicTitle: UILabel!
    @IBOutlet weak var englishSubtitle: UILabel!
    @IBOutlet weak var englishTitle: UILabel!
    @IBOutlet private weak var englishView: UIView!
    @IBOutlet private weak var arabicView: UIView!
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet weak var englishImgView: UIImageView!
    @IBOutlet weak var arabicImgView: UIImageView!
    @IBAction func continueButtonPressed(_ sender: Any) {
        handleViewActions?(.continueButtonPressed)
    }
    
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
        englishViewTapped()
    }
    
    func setupView() {
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
                arabicTitle.textColor = .white
                arabicSubtitle.textColor = .white.withAlphaComponent(0.8)
                arabicView.borderColor = AppColors.LanguagePrefScreen.selectedBorder
                arabicImgView.image = AppImages.LanguagePrefScreen.selected
            case .unselected:
                arabicTitle.textColor = .white.withAlphaComponent(0.6)
                arabicSubtitle.textColor = .white.withAlphaComponent(0.7)
                arabicView.borderColor = AppColors.LanguagePrefScreen.unselectedBorder
                arabicImgView.image = AppImages.LanguagePrefScreen.unSelected
            }
        case .english:
            switch state {
            case .selected:
                englishTitle.textColor = .white
                englishSubtitle.textColor = .white.withAlphaComponent(0.8)
                englishView.borderColor = AppColors.LanguagePrefScreen.selectedBorder
                englishImgView.image = AppImages.LanguagePrefScreen.selected
            case .unselected:
                englishTitle.textColor = .white.withAlphaComponent(0.6)
                englishSubtitle.textColor = .white.withAlphaComponent(0.7)
                englishView.borderColor = AppColors.LanguagePrefScreen.unselectedBorder
                englishImgView.image = AppImages.LanguagePrefScreen.unSelected
            }
        }
    }
}
