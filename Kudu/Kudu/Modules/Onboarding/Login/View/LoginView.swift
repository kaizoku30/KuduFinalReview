//
//  LoginView.swift
//  Kudu
//
//  Created by Admin on 12/05/22.
//

import UIKit

class LoginView: UIView {
    
    // MARK: Constraints
    @IBOutlet private weak var errorLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: Outlets
    @IBOutlet private weak var pleaseEnterPhoneNumberLbl: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var errorImgView: UIImageView!
    @IBOutlet private weak var countryCodeView: UIView!
    @IBOutlet private weak var phoneNumberView: UIView!
    @IBOutlet private weak var getOtpButton: AppButton!
    //@IBOutlet private weak var phoneNumberTFView: AppTextFieldView!
    @IBOutlet private weak var signUpTextView: TappableTextView!
    @IBOutlet private weak var bottomContainer: UIView!
    @IBOutlet weak var phoneNumberTxtField: UITextField!
    
    // MARK: Actions
    @IBAction func continueWithGoogle(_ sender: Any) {
      //  SKToast.show(withMessage: "Under Development")
        self.handleViewActions?(.googleLogin)
    }
    
    @IBAction func continueWithTwitter(_ sender: Any) {
       // SKToast.show(withMessage: "Under Development")
        self.handleViewActions?(.twitterLogin)
    }
    
    @IBAction func continueWithFB(_ sender: Any) {
       // SKToast.show(withMessage: "Under Development")
        self.handleViewActions?(.facebookLogin)
    }
    
    @IBAction func continueWithApple(_ sender: Any) {
     //   SKToast.show(withMessage: "Under Development")
        self.handleViewActions?(.appleLogin)
    }
    
    @IBAction func getOtpButtonPressed(_ sender: Any) {
        self.handleViewActions?(.loginButtonPressed)
    }
    
    // MARK: Variables
    var getMobileNumberEntered: String { phoneNumberTxtField.text ?? "" }
    var handleViewActions: ((ViewActions) -> Void)?
    
    enum ViewActions {
        case loginButtonPressed
        case googleLogin
        case twitterLogin
        case facebookLogin
        case appleLogin
    }
    
    enum APICalled {
        case loginAPI
        case socialAPI
    }
    
    private enum ButtonState {
        case enabled
        case disabled
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    private func initialSetup() {
        phoneNumberView.semanticContentAttribute = .forceLeftToRight
        countryCodeView.semanticContentAttribute = .forceLeftToRight
        errorImgView.semanticContentAttribute = .forceLeftToRight
        phoneNumberTxtField.semanticContentAttribute = .forceLeftToRight
        phoneNumberTxtField.textAlignment = .left
        bottomContainer.roundTopCorners(cornerRadius: 32)
        errorImgView.isUserInteractionEnabled = true
        errorImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(errorImgViewTapped)))
    }
    
    func setupView(delegate: LoginVC) {
        getOtpButton.setTitle(LocalizedStrings.Login.enterPhoneNumber, for: .normal)
        pleaseEnterPhoneNumberLbl.text = LocalizedStrings.Login.pleaseEnterYourPhoneNumber
        signUpTextView.delegate = delegate
        setUpSignUpLabel()
        setupTextField()
    }
    
    func resetLoginField(msg: String) {
        getOtpButton.stopBtnLoader()
        setupButton(state: .disabled)
        phoneNumberTxtField.text = ""
        if msg != "" {
            toggleErrorLabel(msg, show: true, excludeErrorImg: true)
        }
    }
    
    private func toggleErrorLabel(_ msg: String, show: Bool, excludeErrorImg: Bool = false) {
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            self.errorLabel.text = msg
            self.errorLabel.adjustsFontSizeToFitWidth = true
            self.errorLabelHeightConstraint.constant = show == true ? 18 : 0
            if excludeErrorImg == false {
                self.errorImgView.image = show == true ? AppImages.LoginScreen.failureCircle : AppImages.LoginScreen.successCircle
                self.errorImgView.isHidden = !show
            }
            if show {
                UIView.animate(withDuration: 1.0, animations: {
                     self.layoutIfNeeded()
                })
            }
        }
    }
    
    @objc private func errorImgViewTapped() {
        phoneNumberTxtField.text = ""
        phoneNumberTxtField.becomeFirstResponder()
        setupButton(state: .disabled)
    }
    
    private func setupButton(state: ButtonState) {
        if state == .enabled {
            getOtpButton.setTitle("Get OTP", for: .normal)
            getOtpButton.isUserInteractionEnabled = true
            getOtpButton.backgroundColor = AppColors.LoginScreen.selectedBgButtonColor
            getOtpButton.setTitleColor(.white, for: .normal)
        } else {
            getOtpButton.setTitle(LocalizedStrings.Login.enterPhoneNumber, for: .normal)
            getOtpButton.isUserInteractionEnabled = false
            getOtpButton.backgroundColor = AppColors.LoginScreen.unselectedButtonBg
            getOtpButton.setTitleColor(AppColors.LoginScreen.unselectedButtonTextColor, for: .normal)
        }
    }
    
    private func setUpSignUpLabel() {
        let regularText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: AppFonts.mulishRegular.withSize(12), NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.6)])
        let tappableText = NSMutableAttributedString(string: "Sign up")
        tappableText.addAttributes([.font: AppFonts.mulishRegular.withSize(12), .link: "SignUp", .foregroundColor: AppColors.kuduThemeBlue], range: NSRange(location: 0, length: "Sign up".count))
        signUpTextView.tintColor = AppColors.kuduThemeBlue
        signUpTextView.isSelectable = true
        signUpTextView.isUserInteractionEnabled = true
        regularText.append(tappableText)
        signUpTextView.attributedText = regularText
        signUpTextView.textAlignment = .center
    }
    
}

extension LoginView: UITextFieldDelegate {
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.toggleErrorLabel("", show: false)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if (textField.text ?? "").count == 9 {
            textField.resignFirstResponder()
            self.setupButton(state: .enabled)
        } else {
            self.setupButton(state: .disabled)
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

extension LoginView {
    func handleAPIRequest(_ api: APICalled) {
        switch api {
        case .loginAPI:
            toggleErrorLabel("", show: false)
            getOtpButton.startBtnLoader(color: .white)
        case .socialAPI:
            toggleErrorLabel("", show: false)
            getOtpButton.startBtnLoader(color: .white)
        }
    }
    
    func handleAPIResponse( _ api: APICalled, isSuccess: Bool, errorMsg: String?) {
        switch api {
        case .loginAPI:
            self.getOtpButton.stopBtnLoader()
            if isSuccess {
                toggleErrorLabel("", show: false)
                getOtpButton.stopBtnLoader()
            } else {
                self.toggleErrorLabel(errorMsg ?? "", show: true)
            }
        case .socialAPI:
            self.getOtpButton.stopBtnLoader()
            if errorMsg.isNotNil {
                self.toggleErrorLabel(errorMsg ?? "", show: true, excludeErrorImg: true)
            }
        }
    }
}
