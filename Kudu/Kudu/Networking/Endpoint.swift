import Foundation
import Alamofire

enum SocialLoginType: String {
    case facebook
    case google
    case apple
    case twitter
}

enum Endpoint {
    // MARK: PRELOGIN END POINTS
    case login(mobileNo: String, countryCode: String)
    case sendOtp(mobileNo: String, countryCode: String = "966", email: String?)
    case signUp(fullName: String, email: String?, mobileNo: String, countryCode: String = "966", deviceId: String = "123", deviceToken: String = "321")
    case verifyMobileOtp(fullName: String?, email: String?, mobileNo: String, countryCode: String = "966", mobileOtp: String, deviceId: String = "123", deviceToken: String = "321")
    case socialLogIn(socialLoginType: SocialLoginType, socialId: String, deviceId: String = "123", deviceToken: String = "321")
    case socialSignup(socialLoginType: SocialLoginType, socialId: String, fullName: String, mobileNo: String, email: String?, countryCode: String = "966", deviceId: String = "123", deviceToken: String = "321")
    case socialVerification(socialLoginType: SocialLoginType, socialId: String, fullName: String, mobileNo: String, email: String?, mobileOtp: String, countryCode: String = "966", deviceId: String = "123", deviceToken: String = "321")
    case logout
    case payment(cardToken: String)
    
    /// GET, POST or PUT method for each request
    var method: Alamofire.HTTPMethod {
        switch self {
        case .payment, .login, .sendOtp, .verifyMobileOtp, .socialSignup, .socialVerification, .logout, .signUp, .socialLogIn:
            return .post
        }
    }
    
    /// URLEncoding used for GET requests and JSONEncoding for POST and PUT requests
    var encoding: Alamofire.ParameterEncoding {
        if self.method == .get {
            return URLEncoding.default
        } else {
            return JSONEncoding.default
        }
    }
    
    /// URL string for each request
    var path: String {
        let baseUrl = Environment().configuration(.kBaseUrl)
        let registerIntermediate = "/userOnboard/api/v1/"
        switch self {
        case .login, .verifyMobileOtp, .signUp, .logout, .sendOtp, .socialLogIn, .socialSignup, .socialVerification:
            return baseUrl + registerIntermediate + apiPath
        case .payment:
            return Constants.CheckOutCredentials.postApiURL
        }
    }
    
    var apiPath: String {
        switch self {
        case .login:
            return "login"
        case .signUp:
            return "signup"
        case .verifyMobileOtp:
            return "verifyMobileOtp"
        case .logout:
            return "logout"
        case .sendOtp:
            return "sendOtp"
        case .socialLogIn:
            return "socialLogin"
        case .socialSignup:
            return "socialSignup"
        case .socialVerification:
            return "socialVerification"
        default:
            return ""
        }
    }
    
    /// parameters Dictionary for each request
    var parameters: [String: Any] {
        switch self {
        case .payment(let cardToken):
            return ["source": ["type": "token", "token": cardToken],
                    "amount": 1, "currency": "USD", "reference": "ORD=5023-4E38"]
        case .login(let mobileNo, let countryCode):
            return [Constants.APIKeys.mobileNo.rawValue: mobileNo,
                    Constants.APIKeys.countryCode.rawValue: countryCode]
        case .signUp(let fullName, let email, let mobileNo, let countryCode, let deviceId, let deviceToken):
            var params: [String: Any] = [Constants.APIKeys.fullName.rawValue: fullName,
                                        Constants.APIKeys.mobileNo.rawValue: mobileNo,
                                        Constants.APIKeys.countryCode.rawValue: countryCode,
                                        Constants.APIKeys.deviceId.rawValue: deviceId,
                                        Constants.APIKeys.deviceToken.rawValue: deviceToken]
            if let email = email {
                params[Constants.APIKeys.email.rawValue] = email
            }
            return params
        case .verifyMobileOtp(let fullName, let email, let mobileNo, let countryCode, let mobileOtp, let deviceId, let deviceToken):
            var params: [String: Any] = [Constants.APIKeys.mobileNo.rawValue: mobileNo,
                                        Constants.APIKeys.countryCode.rawValue: countryCode,
                                        Constants.APIKeys.deviceId.rawValue: deviceId,
                                        Constants.APIKeys.deviceToken.rawValue: deviceToken,
                                        Constants.APIKeys.mobileOtp.rawValue: mobileOtp]
            if let email = email {
                params[Constants.APIKeys.email.rawValue] = email
            }
            if let fullName = fullName {
                params[Constants.APIKeys.fullName.rawValue] = fullName
            }
            return params
        case .sendOtp(let mobileNo, let countryCode, let email):
            var params: [String: Any] = [Constants.APIKeys.mobileNo.rawValue: mobileNo,
                                        Constants.APIKeys.countryCode.rawValue: countryCode]
            if let email = email {
                params[Constants.APIKeys.email.rawValue] = email
            }
            return params
        case .socialLogIn(let socialLoginType, let socialId, let deviceId, let deviceToken):
            let params: [String: Any] = [Constants.APIKeys.socialLoginType.rawValue: socialLoginType.rawValue,
                                         Constants.APIKeys.socialId.rawValue: socialId,
                                         Constants.APIKeys.deviceId.rawValue: deviceId,
                                         Constants.APIKeys.deviceToken.rawValue: deviceToken]
            return params
        case .socialSignup(let socialLoginType, let socialId, let fullName, let mobileNo, let email, let countryCode, let deviceId, let deviceToken) :
            var params: [String: Any] = [Constants.APIKeys.fullName.rawValue: fullName,
                                        Constants.APIKeys.mobileNo.rawValue: mobileNo,
                                        Constants.APIKeys.countryCode.rawValue: countryCode,
                                        Constants.APIKeys.deviceId.rawValue: deviceId,
                                        Constants.APIKeys.deviceToken.rawValue: deviceToken,
                                         Constants.APIKeys.socialLoginType.rawValue: socialLoginType.rawValue,
                                         Constants.APIKeys.socialId.rawValue: socialId]
            if email.isNotNil {
                params[Constants.APIKeys.email.rawValue] = email!
            }
            return params
        case .socialVerification(let socialLoginType, let socialId, let fullName, let mobileNo, let email, let mobileOtp, let countryCode, let deviceId, let deviceToken):
            var params: [String: Any] = [Constants.APIKeys.fullName.rawValue: fullName,
                                        Constants.APIKeys.mobileNo.rawValue: mobileNo,
                                        Constants.APIKeys.countryCode.rawValue: countryCode,
                                        Constants.APIKeys.deviceId.rawValue: deviceId,
                                        Constants.APIKeys.deviceToken.rawValue: deviceToken,
                                         Constants.APIKeys.socialLoginType.rawValue: socialLoginType.rawValue,
                                         Constants.APIKeys.socialId.rawValue: socialId,
                                         Constants.APIKeys.mobileOtp.rawValue: mobileOtp]
            if email.isNotNil {
                params[Constants.APIKeys.email.rawValue] = email!
            }
            return params
        default:
            return [:]
        }
    }
    
    /// http header for each request (if needed)
    var header: HTTPHeaders? {
        var currentLanguage = AppUserDefaults.value(forKey: .selectedLanguage) as? String ?? ""
        if currentLanguage == "" {
            currentLanguage = AppUserDefaults.Language.en.rawValue
        }
        var headers = ["platform": "2", "language": currentLanguage]
        switch self {
        case .payment:
            headers = [:]
            headers["authorization"] = "sk_test_146d56ed-4dcd-493a-9db2-866c924c0bba"
        case .logout:
            headers["api_key"] = "123456"
            headers["authorization"] = "Bearer \(DataManager.shared.loginResponse?.accessToken ?? "")"
        default:
            headers["authorization"] = "Basic \(Constants.BasicAuthCredentials.b64String)"
        }
        headers["xApiPath"] = self.apiPath
        return HTTPHeaders(headers)
    }
}
