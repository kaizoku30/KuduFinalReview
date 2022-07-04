//
//  DataManger.swift
//  Kudu
//
//  Created by Admin on 02/05/22.
//

import Foundation
import UIKit

final class DataManager {
    
    static let shared = DataManager()
    var loginResponse: LoginUserData? {
        didSet {
            if loginResponse.isNotNil {
                debugPrint("Updated Login Response in Cache")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(loginResponse!) {
                    AppUserDefaults.save(value: encoded, forKey: .loginResponse)
                }
            }
           
        }
    }
    
    private init() {
        if let savedLoginData = AppUserDefaults.value(forKey: .loginResponse) as? Data {
            let decoder = JSONDecoder()
            if let loadedLoginData = try? decoder.decode(LoginUserData.self, from: savedLoginData) {
                loginResponse = loadedLoginData
                print("Access token present : \(loadedLoginData)")
            }
        }
    }
    
}
