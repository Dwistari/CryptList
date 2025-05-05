//
//  UserDefault.swift
//  CrypList
//
//  Created by Dwistari on 01/05/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.string(forKey: "loggedInUserEmail") != nil
    }
    
    func login(email: String) {
        UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInUserEmail")
    }
}
