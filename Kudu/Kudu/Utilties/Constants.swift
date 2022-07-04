//
//  Constants.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import Foundation
import GoogleSignIn

class Constants {
    struct BasicAuthCredentials {
        static var apiUserNameAndPass = "kuduApp:kuduApp@123"
        static var b64String: String {
                let data = apiUserNameAndPass.data(using: String.Encoding.utf8)
                return data?.base64EncodedString() ?? ""
        }
    }
    
    struct CheckOutCredentials {
        static let postApiURL = "https://api.sandbox.checkout.com/payments"
    }
    
    struct GoogleSingInCredentials {
        static let signInConfig = GIDConfiguration(clientID: "952805797575-sj2m31v6gc9cj8aa8u9ib0g23fa1gjq7.apps.googleusercontent.com")
    }
    
    struct TwitterCredentials {
        static let apiKey = "y3c1y8ZDb0Bt7UeV1G7SiqvWd"
        static let apiKeySecret = "VFE1XCNpks2k3oMoOjQlYbRtQ0JaxcEukqTESyy10f5tPdW93H"
        static let scheme = "twittersdk"
    }
    
    struct S3BucketCredentials {
        static let s3PoolApiKey = "us-east-1:ddd74fa1-9d1a-4370-af14-26980e40e7a2"
        static let s3BucketName = "app-development"
        static let s3BaseUrl = "https://app-development.s3.amazonaws.com/"
    }
    
    struct StatusCode {
        static let blocked = 401
        static let delete = 401
      //  static let OTP_EXPIRED = 400
    }
    
    enum NotificationObservers: String {
        case pushLoginVC
        case sessionExpired
        case resetLoginState
        case videoThumbnailsUpdated
        case twitterCallBack
        case endTutorialFlow
    }
    
    enum APIKeys: String {
        case mobileNo
        case countryCode
        case fullName
        case email
        case deviceId
        case deviceToken
        case mobileOtp
        case socialLoginType
        case socialId
    }
    
    enum MediaTypes: String {
        case kImage  = "public.image"
        case kVideo  = "public.movie"
        
        var intVal: Int {
            switch self {
            case .kImage:
                return 1
            case .kVideo:
                return 2
            }
        }
    }

    enum S3MediaType: Int {
        case image = 1
        case video = 2
    }
    
    struct CustomViewTags {
        static let bottomSheetOverlay = 100001
        static let dimViewTag = 123456
        static let alertTag = 123455
        static let changeExpTag = 123454
    }
}
