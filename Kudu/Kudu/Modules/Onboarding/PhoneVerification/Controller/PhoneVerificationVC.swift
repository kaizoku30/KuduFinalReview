//
//  PhoneVerificationVC.swift
//  Kudu
//
//  Created by Admin on 17/05/22.
//

import UIKit
import WebKit
import OTPFieldView

class PhoneVerificationVC: BaseVC {
    @IBOutlet private weak var baseView: PhoneVerificationView!
    var viewModel: PhoneVerificationVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.setupView(mobileNum: viewModel?.getMobileNumber ?? "")
        handleActions()
    }
    
    private func handleActions() {
        baseView.handleViewActions = { [weak self] in
            guard let strongSelf = self else { return }
            switch $0 {
            case .verifyButtonPressed(let otpString):
                debugPrint(otpString)
                strongSelf.baseView.handleAPIRequest(.verifyMobileOtpAPI)
                strongSelf.viewModel?.verifyMobileOTP(otpString)
            case  .resendOtpPressed:
                strongSelf.baseView.handleAPIRequest(.resendOtp)
                strongSelf.viewModel?.resendOTP()
            case .dismissVC:
                strongSelf.pop()
            }
        }
    }
}

extension PhoneVerificationVC: PhoneVerificationVMDelegate {
    func verifyMobileAPIResponse(responseType: Result<LoginUserData?, Error>) {
        switch responseType {
        case .success(let result):
            debugPrint(result ?? "")
            self.baseView.handleAPIResponse(.verifyMobileOtpAPI, isSuccess: true, errorMsg: nil)
            DataManager.shared.loginResponse = result
            let vc = DevelopmentPlaceholderVC.instantiate(fromAppStoryboard: .Onboarding)
            self.push(vc: vc)
        case .failure(let error):
            self.baseView.handleAPIResponse(.verifyMobileOtpAPI, isSuccess: false, errorMsg: error.localizedDescription)
            debugPrint(error)
        }
    }
}

//extension PhoneVerificationVC: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        if URL.absoluteString == "EditPhoneNumberLink" {
//            return false
//        }
//
//        return true
//    }
//
//}
