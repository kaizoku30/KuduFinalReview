//
//  LS.swift
//  Kudu
//
//  Created by Admin on 11/05/22.
//

import Foundation

final class LocalizedStrings {
    struct Tutorial {
        static var greatTasteLabel: String { "greatTasteLabel".localize() }
        static var getFoodDelivery: String { "getFoodDelivery".localize() }
        static var continueButtonTitle: String { "Continue".localize() }
        static var skip: String { "skip".localize() }
    }
    
    struct Login {
        static var phoneNo: String { "phoneNo".localize() }
        static var helloSignIn: String { "helloSignIn".localize() }
        static var phoneNotRegistered: String { "phoneNotRegistered".localize() }
        static var login: String { "login".localize() }
        static var continueGoogle: String { "continueGoogle".localize() }
        static var continueFacebook: String { "continueFacebook".localize() }
        static var continueTwitter: String { "continueTwitter".localize() }
        static var continueWithApple: String { "continueWithApple".localize() }
        static var dontHaveAnAccount: String { "dontHaveAnAccount".localize() }
        static var signUp: String { "signUp".localize() }
        static var pleaseEnterYourPhoneNumber: String { "pleaseEnterYourPhoneNumber".localize() }
        static var enterPhoneNumber: String { "enterPhoneNumber".localize() }
    }
    
    struct SignUp {
        static var phoneNo: String { "phoneNo".localize() }
        static var name: String { "name".localize() }
        static var emailId: String { "emailId".localize() }
        static var pleaseEnterFullName: String { "pleaseEnterFullName".localize() }
        static var pleaseEnterPhoneNumber: String { "pleaseEnterPhoneNumber".localize() }
        static var pleaseEnterValidFullName: String { "pleaseEnterValidFullName".localize() }
        static var pleaseEnterValidPhoneNumber: String { "pleaseEnterValidPhoneNumber".localize() }
        static var pleaseEnterValidEmail: String { "pleaseEnterValidEmail".localize() }
        static var enterYourName: String { "enterYourName".localize() }
        static var enterYourEmailOptional: String { "enterYourEmailOptional".localize()}
        static var enterYourPhoneNumber: String { "enterYourPhoneNumber".localize() }
        static var alreadyHaveAnAccount: String { "alreadyHaveAnAccount".localize() }
        static var signIn: String { "signIn".localize() }
    }
    
    struct PhoneVerification {
        static var weHaveSentCode: String { "weHaveSentCode".localize() }
        static var phoneNumberVerification: String { "phoneNumberVerification".localize() }
        static var verifyPhoneNumber: String { "verifyPhoneNumber".localize() }
        static var differentNumberQ: String { "differentNumberQ".localize() }
        static var verify: String { "verify".localize() }
    }
}
