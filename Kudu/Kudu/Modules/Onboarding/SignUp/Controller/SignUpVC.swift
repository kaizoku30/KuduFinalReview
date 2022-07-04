//
//  SignUpVC.swift
//  Kudu
//
//  Created by Admin on 28/05/22.
//

import UIKit

class SignUpVC: BaseVC {
    @IBOutlet private weak var baseView: SignUpView!
    var viewModel: SignUpVM?
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.isNil {
            viewModel = SignUpVM(_delegate: self)
        }
        baseView.setupView(delegate: self, socialData: viewModel?.getSocialData)
        handleViewActions()
    }
    
    private func handleViewActions() {
        baseView.handleViewActions = { [weak self] in
            guard let strongSelf = self, let viewModel = strongSelf.viewModel else { return }
            switch $0 {
            case .signUpButtonPressed:
                let validation = viewModel.validateData(name: strongSelf.baseView.getName, phoneNum: strongSelf.baseView.getPhoneNum, email: strongSelf.baseView.getEmail)
                if validation.result == false {
                    strongSelf.baseView.showError(message: validation.error)
                } else {
                    strongSelf.baseView.handleAPIRequest()
                    if viewModel.getSocialData.isNotNil {
                        viewModel.socialSignUp(name: strongSelf.baseView.getName, phoneNum: strongSelf.baseView.getPhoneNum, email: strongSelf.baseView.getEmail)
                    } else {
                        viewModel.signUp(name: strongSelf.baseView.getName, phoneNum: strongSelf.baseView.getPhoneNum, email: strongSelf.baseView.getEmail)
                    }
                }
            case .dismissVC:
                strongSelf.pop()
            case .mergeData:
                self?.baseView.handleAPIRequest()
                self?.viewModel?.resendOTP(phoneNumber: self?.baseView.getPhoneNum ?? "", email: nil)
            }
        }
    }
    
}

extension SignUpVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "goToSignIn" {
            self.pop()
            return false
        }
        
        if URL.absoluteString == "goToTermsOfUse" || URL.absoluteString == "goToPrivacyPolicy" {
            SKToast.show(withMessage: "Under Development")
            return false
        }
        
        return true
    }
}

extension SignUpVC: SignUpVMDelegate {
    func signUpAPIResponse(responseType: Result<String, Error>) {
        switch responseType {
        case .success(let result) :
            debugPrint(result)
            self.baseView.handleAPIResponse(isSuccess: true, errorMsg: nil)
            let phoneVerificationVC = PhoneVerificationVC.instantiate(fromAppStoryboard: .Onboarding)
            let signUpRequest = SignUpRequest(email: self.baseView.getEmail, name: self.baseView.getName, mobileNum: self.baseView.getPhoneNum)
            phoneVerificationVC.viewModel = PhoneVerificationVM(_signUpReq: signUpRequest, loginMobileNo: nil, _delegate: phoneVerificationVC, flowType: .comingFromSignUp)
            self.navigationController?.pushViewController(phoneVerificationVC, animated: true)
        case .failure(let error) :
            self.baseView.handleAPIResponse(isSuccess: false, errorMsg: error.localizedDescription)
        }
    }
    
    func socialSignUpAPIResponse(responseType: Result<String, Error>) {
        switch responseType {
        case .success(let result) :
            debugPrint(result)
            self.baseView.handleAPIResponse(isSuccess: true, errorMsg: nil)
            let phoneVerificationVC = PhoneVerificationVC.instantiate(fromAppStoryboard: .Onboarding)
            let socialSignUpReq = self.viewModel?.getSocialData
            phoneVerificationVC.viewModel = PhoneVerificationVM(_socialSignUpReq: socialSignUpReq, loginMobileNo: nil, _delegate: phoneVerificationVC, flowType: .comingFromSignUp)
            self.navigationController?.pushViewController(phoneVerificationVC, animated: true)
        case .failure(let error) :
            self.baseView.handleAPIResponse(isSuccess: false, errorMsg: error.localizedDescription)
        }
    }
    
    func showMergingAlert() {
        self.baseView.handleAPIResponse(isSuccess: false, errorMsg: nil, showMergeConflict: true)
    }
    
}
