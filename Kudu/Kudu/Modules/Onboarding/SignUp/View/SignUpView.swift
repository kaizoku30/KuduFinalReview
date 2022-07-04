//
//  SignUpView.swift
//  Kudu
//
//  Created by Admin on 28/05/22.
//

import UIKit

class SignUpView: UIView {
    
    @IBOutlet weak var phoneContainerView: UIView!
    @IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var nameTFView: AppTextFieldView!
    @IBOutlet weak var emailTFView: AppTextFieldView!
   // @IBOutlet weak var mobileNoTFView: AppTextFieldView!
    @IBOutlet weak var errorToastView: AppErrorToastView!
    @IBOutlet weak var signUpButton: AppButton!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    @IBAction func dismissButtonPressed(_ sender: Any) {
        handleViewActions?(.dismissVC)
    }
    @IBOutlet weak var alreadyHaveAnAccountView: TappableTextView!
    @IBOutlet weak var termsAndConditionsView: TappableTextView!
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        handleViewActions?(.signUpButtonPressed)
//        errorToastView.showErrorToast(topAnchor: errorTopAnchor, heightAnchor: errorHeightConstraint, message: "asdasdjasldasldjsalkdasdasdioasdasdasdasdasdasdiiasdsakjdhasdkjsadkjhsajdkashdaskjdhsakjdhsakjdhaskjdhjksadjh")
    }
    
    var handleViewActions: ((ViewActions) -> Void)?
    var getName: String {
        nameTFView.currentText
    }
    var getEmail: String? {
        emailTFView.currentText == "" ? nil : emailTFView.currentText
    }
    var getPhoneNum: String {
        phoneNumberTxtField.text ?? ""
    }
    enum ViewActions {
        case signUpButtonPressed
        case dismissVC
        case mergeData
    }
    private var appPopUp: AppPopUpView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAlreadyHaveAnAccountView()
        setupTermsAndConditionsView()
        phoneContainerView.semanticContentAttribute = .forceLeftToRight
        phoneNumberTxtField.semanticContentAttribute = .forceLeftToRight
        setupTextField()
        nameTFView.textFieldType = .name
        emailTFView.textFieldType = .email
        phoneNumberTxtField.textColor = emailTFView.textColor
        nameTFView.placeholderText = LocalizedStrings.SignUp.enterYourName
        emailTFView.placeholderText = LocalizedStrings.SignUp.enterYourEmailOptional
        phoneNumberTxtField.placeholder = LocalizedStrings.SignUp.enterYourPhoneNumber
        
    }
    
    func setupView(delegate: SignUpVC, socialData: SocialSignUpRequest? = nil) {
        alreadyHaveAnAccountView.delegate = delegate
        termsAndConditionsView.delegate = delegate
        if let socialInfo = socialData {
            self.showError(message: "This social account is not registered with us. Please fill the necessary details to complete Sign Up.", extraDelay: 1.5)
            prefillSocialInfo(socialInfo)
        }
    }
    
    private func prefillSocialInfo(_ data: SocialSignUpRequest) {
        if let name = data.name {
            nameTFView.currentText = name
        }
        if let email = data.email {
            emailTFView.currentText = email
        }
    }
    
    private func setupAlreadyHaveAnAccountView() {
        let regularText = NSMutableAttributedString(string: LocalizedStrings.SignUp.alreadyHaveAnAccount, attributes: [NSAttributedString.Key.font: AppFonts.mulishRegular.withSize(12), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.7)])
        let tappableText = NSMutableAttributedString(string: LocalizedStrings.SignUp.signIn)
        tappableText.addAttributes([.font: AppFonts.mulishMedium.withSize(12), .link: "goToSignIn", .foregroundColor: AppColors.kuduThemeBlue], range: NSRange(location: 0, length: LocalizedStrings.SignUp.signIn.count))
        tappableText.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: AppColors.kuduThemeBlue], range: NSRange(location: 0, length: LocalizedStrings.SignUp.signIn.count))
        alreadyHaveAnAccountView.tintColor = AppColors.kuduThemeBlue
        alreadyHaveAnAccountView.isSelectable = true
        alreadyHaveAnAccountView.isUserInteractionEnabled = true
        regularText.append(tappableText)
        alreadyHaveAnAccountView.attributedText = regularText
        alreadyHaveAnAccountView.textAlignment = .center
    }
    
    private func setupTermsAndConditionsView() {
        let greyColor = AppColors.SignUpScreen.termsAndConditionsGrey
        let regularText = NSMutableAttributedString(string: "By signing up, you agree to the ", attributes: [NSAttributedString.Key.font: AppFonts.mulishRegular.withSize(10), NSAttributedString.Key.foregroundColor: greyColor])
        let termsOfUse = NSMutableAttributedString(string: "Terms of use")
        termsOfUse.addAttributes([.font: AppFonts.mulishBold.withSize(10), .link: "goToTermsOfUse", .foregroundColor: greyColor], range: NSRange(location: 0, length: "Terms of use".count))
        termsOfUse.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: greyColor], range: NSRange(location: 0, length: "Terms of use".count))
        regularText.append(termsOfUse)
        let andText = NSMutableAttributedString(string: " and ", attributes: [NSAttributedString.Key.font: AppFonts.mulishRegular.withSize(10), NSAttributedString.Key.foregroundColor: greyColor])
        regularText.append(andText)
        let privacyPolicy = NSMutableAttributedString(string: "Privacy Policy")
        privacyPolicy.addAttributes([.font: AppFonts.mulishBold.withSize(10), .link: "goToPrivacyPolicy", .foregroundColor: greyColor], range: NSRange(location: 0, length: "Privacy Policy".count))
        privacyPolicy.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue, .underlineColor: greyColor], range: NSRange(location: 0, length: "Privacy Policy".count))
        regularText.append(privacyPolicy)
        termsAndConditionsView.tintColor = greyColor
        termsAndConditionsView.isSelectable = true
        termsAndConditionsView.isUserInteractionEnabled = true
        
        termsAndConditionsView.attributedText = regularText
        termsAndConditionsView.textAlignment = .center
    }
    
    func showError(message: String, extraDelay: TimeInterval? = nil) {
        errorToastView.showErrorToast(topAnchor: errorTopAnchor, heightAnchor: errorHeightConstraint, message: message, extraDelay: extraDelay)
    }
    
    private func showMergeAlert() {
        appPopUp = AppPopUpView(frame: CGRect(x: 0, y: 0, width: self.width - AppPopUpView.HorizontalPadding, height: AppPopUpView.PopUpHeight))
        appPopUp?.configure(message: "Seems like you already have an account with this number. Do you want to merge your accounts?", leftButtonTitle: "Cancel", rightButtonTitle: "Continue", container: self)
        appPopUp?.handleAction = { [weak self] in
            if $0 == .right {
                self?.handleViewActions?(.mergeData)
            }
        }
    }
    
}

extension SignUpView: UITextFieldDelegate {
        private func setupTextField() {
            phoneNumberTxtField.keyboardType = .phonePad
            phoneNumberTxtField.delegate = self
            phoneNumberTxtField.textContentType = UITextContentType(rawValue: "")
            phoneNumberTxtField.autocorrectionType = .no
            phoneNumberTxtField.autocapitalizationType = .none
            phoneNumberTxtField.spellCheckingType = .no
            phoneNumberTxtField.tintColor = AppColors.darkGray
            phoneNumberTxtField.placeholder = ""
            phoneNumberTxtField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
//        func textFieldDidBeginEditing(_ textField: UITextField) {
//            self.toggleErrorLabel("", show: false)
//        }
        
        @objc private func textFieldDidChange(_ textField: UITextField) {
            if (textField.text ?? "").count == 9 {
                textField.resignFirstResponder()
               // self.setupButton(state: .enabled)
            } else {
               // self.setupButton(state: .disabled)
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let text: NSString = (textField.text ?? "") as NSString
            let newString = text.replacingCharacters(in: range, with: string)
            return self.validatePhoneNumber(newString, string)
        }
        
        private func validatePhoneNumber(_ newString: String, _ string: String) -> Bool {
            let allowed = CharacterSet(charactersIn: "1234567890")
            let enteredCharacterSet = CharacterSet(charactersIn: newString)
            if !enteredCharacterSet.isSubset(of: allowed) || newString.count > 9 {
                return false
            }
            return true
        }
}

extension SignUpView {
    
    func handleAPIRequest() {
        signUpButton.startBtnLoader(color: .white)
        [nameTFView, phoneNumberTxtField, emailTFView].forEach({ $0?.isUserInteractionEnabled = true })
    }
    
    func handleAPIResponse(isSuccess: Bool, errorMsg: String?, showMergeConflict: Bool = false) {
        mainThread {
            self.signUpButton.stopBtnLoader()
            
            if showMergeConflict {
                self.showMergeAlert()
                return
            }
            
            if isSuccess {
                
            } else {
                self.showError(message: errorMsg ?? "")
            }
        }
    }
    
}
