//
//  PaymentTestEndPoints.swift
//  Kudu
//
//  Created by Admin on 28/04/22.
//

import Foundation

class WebServices {
    
    final class OnboardingEndPoints {
        static func login(mobileNo: String, countryCode: String = "966", success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .login(mobileNo: mobileNo, countryCode: countryCode), successHandler: success, failureHandler: failure)
        }
        static func signUp(name: String, mobileNo: String, email: String?, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .signUp(fullName: name, email: email, mobileNo: mobileNo), successHandler: success, failureHandler: failure)
        }
        static func verifyMobileOtp(signUpRequest: SignUpRequest, mobileOtp: String, success: @escaping SuccessCompletionBlock<OTPVerificationResponseModel>, failure: @escaping ErrorFailureCompletionBlock) {
            let name = signUpRequest.name
            let email = signUpRequest.email
            let mobileNo = signUpRequest.mobileNum
            Api.requestNew(endpoint: .verifyMobileOtp(fullName: name, email: email, mobileNo: mobileNo, mobileOtp: mobileOtp), successHandler: success, failureHandler: failure)
        }
        static func verifyMobileOtpLogin(mobileNum: String, mobileOtp: String, success: @escaping SuccessCompletionBlock<OTPVerificationResponseModel>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .verifyMobileOtp(fullName: nil, email: nil, mobileNo: mobileNum, mobileOtp: mobileOtp), successHandler: success, failureHandler: failure)
        }
        static func sendOtp(mobileNo: String, email: String?, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .sendOtp(mobileNo: mobileNo, email: email), successHandler: success, failureHandler: failure)
        }
        static func socialLogin(socialLoginType: SocialLoginType, socialId: String, success: @escaping SuccessCompletionBlock<SocialLoginResponseModel>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .socialLogIn(socialLoginType: socialLoginType, socialId: socialId), successHandler: success, failureHandler: failure)
        }
        static func socialSignUp(signUpReq: SocialSignUpRequest, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .socialSignup(socialLoginType: signUpReq.socialLoginType, socialId: signUpReq.socialId, fullName: signUpReq.name ?? "", mobileNo: signUpReq.mobileNum ?? "", email: signUpReq.email), successHandler: success, failureHandler: failure)
        }
        static func socialVerification(signUpReq: SocialSignUpRequest, otp: String, success: @escaping SuccessCompletionBlock<OTPVerificationResponseModel>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .socialVerification(socialLoginType: signUpReq.socialLoginType, socialId: signUpReq.socialId, fullName: signUpReq.name ?? "", mobileNo: signUpReq.mobileNum ?? "", email: signUpReq.email, mobileOtp: otp), successHandler: success, failureHandler: failure)
        }
        static func logout(success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .logout, successHandler: success, failureHandler: failure)
        }
    }
    
    final class PaymentTestEndPoints {
        static func payADollar(cardToken: String, success: @escaping SuccessCompletionBlock<EmptyDataResponse>, failure: @escaping ErrorFailureCompletionBlock) {
            Api.requestNew(endpoint: .payment(cardToken: cardToken), successHandler: success, failureHandler: failure)
        }
    }
}

struct GetQuestionsResponse: Codable {
    var statusCode: Int?
    var message: String?
    var type: String?
    var data: [QuestionsData]?
}

struct QuestionsData: Codable {
    var _id: String?
    var question: String?
    var questionTag: String?
    var order: Int?
}

enum QuestionTagType: String {
    case email = "EMAIL"
    case name = "NAME"
    case password = "PASSWORD"
    case username = "USERNAME"
    case region = "REGION"
    case activity = "ACTIVITY"
}
