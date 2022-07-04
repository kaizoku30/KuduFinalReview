//
//  PhoneVerificationVM.swift
//  Kudu
//
//  Created by Admin on 27/06/22.
//

import Foundation

protocol PhoneVerificationVMDelegate: AnyObject {
    func verifyMobileAPIResponse(responseType: Result<LoginUserData?, Error>)
}

class PhoneVerificationVM {
    
    enum PhoneVerificationFlow {
        case comingFromSignUp
        case comingFromLogin
    }
    
    private var signUpRequest: SignUpRequest?
    private var socialSignUpRequest: SocialSignUpRequest?
    var getMobileNumber: String {
        if flow == .comingFromSignUp {
            if self.socialSignUpRequest.isNotNil {
                return self.socialSignUpRequest?.mobileNum ?? ""
            }
            return self.signUpRequest?.mobileNum ?? ""
        } else {
            return self.loginMobileNumber ?? ""
        } }
    private weak var delegate: PhoneVerificationVMDelegate?
    var getCurrentFlow: PhoneVerificationFlow { self.flow }
    private var flow: PhoneVerificationFlow = .comingFromLogin
    private let webService = WebServices.OnboardingEndPoints.self
    private var loginMobileNumber: String?
    
    init(_signUpReq: SignUpRequest? = nil, _socialSignUpReq: SocialSignUpRequest? = nil, loginMobileNo: String? = nil, _delegate: PhoneVerificationVMDelegate, flowType: PhoneVerificationFlow) {
        self.signUpRequest = _signUpReq
        self.delegate = _delegate
        self.flow = flowType
        self.loginMobileNumber = loginMobileNo
        self.socialSignUpRequest = _socialSignUpReq
    }
    
    func verifyMobileOTP(_ otp: String) {
        if flow == .comingFromSignUp {
            
            if self.socialSignUpRequest.isNotNil {
                verifySocialOTP(otp)
                return
            }
            guard let signUpRequest = signUpRequest else {
                return
            }
            webService.verifyMobileOtp(signUpRequest: signUpRequest, mobileOtp: otp, success: { [weak self] in
                debugPrint($0)
                self?.delegate?.verifyMobileAPIResponse(responseType: .success($0.data))
            }, failure: { [weak self] in
                let error = NSError(code: $0.code, localizedDescription: $0.msg)
                self?.delegate?.verifyMobileAPIResponse(responseType: .failure(error))
            })
        } else {
            webService.verifyMobileOtpLogin(mobileNum: self.getMobileNumber, mobileOtp: otp, success: { [weak self] in
                debugPrint($0)
                self?.delegate?.verifyMobileAPIResponse(responseType: .success($0.data))
            }, failure: { [weak self] in
                let error = NSError(code: $0.code, localizedDescription: $0.msg)
                self?.delegate?.verifyMobileAPIResponse(responseType: .failure(error))
            })
        }
    }
    
    private func verifySocialOTP(_ otp: String) {
        guard let signUpRequest = socialSignUpRequest else {
            return
        }
        webService.socialVerification(signUpReq: signUpRequest, otp: otp, success: { [weak self] in
            debugPrint($0)
            self?.delegate?.verifyMobileAPIResponse(responseType: .success($0.data))
        }, failure: { [weak self] in
            let error = NSError(code: $0.code, localizedDescription: $0.msg)
            self?.delegate?.verifyMobileAPIResponse(responseType: .failure(error))
        })
    }
    
    func resendOTP() {
//        numberOfTriesRemaining -= 1
        let mobileNo = self.getMobileNumber
        let email = self.signUpRequest?.email
        webService.sendOtp(mobileNo: mobileNo, email: email, success: { _ in
        }, failure: { _ in
        })
    }
}
