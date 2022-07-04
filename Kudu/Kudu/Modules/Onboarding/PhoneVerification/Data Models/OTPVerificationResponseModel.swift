//
//  OTPVerificationResponseModel.swift
//  Kudu
//
//  Created by Admin on 28/06/22.
//

import Foundation

struct OTPVerificationResponseModel: Codable {
    let message: String?
    let statusCode: Int?
    let data: LoginUserData?
}

struct LoginUserData: Codable {
    let mobileNo: String?
    let countryCode: String?
    let accessToken: String?
    let userId: String?
}
