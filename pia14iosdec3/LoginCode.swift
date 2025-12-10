//
//  LoginCode.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-10.
//

import Foundation
import FirebaseAuth

@Observable class LoginCode {
    
    var showError : String?
    
    func userlogin(useremail : String, userpassword : String) async {
        
        if useremail == "" {
            showError = "Enter email"
            return
        }
        
        do {
            try await Auth.auth().signIn(withEmail: useremail, password: userpassword)
            
        } catch {
            print("Login error")
            showError = "Login fail"
        }
        
    }
    
    func userregister(useremail : String, userpassword : String) async {
        
        do {
            try await Auth.auth().createUser(withEmail: useremail, password: userpassword)
        } catch {
            showError = error.localizedDescription
        }
        
    }
    
    func forgotpassword(useremail : String) async {
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: useremail)
            showError = "Sent password reset mail"
        } catch {
            showError = "Send fail!!"
        }
        
    }
    
}
