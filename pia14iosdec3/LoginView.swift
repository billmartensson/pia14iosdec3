//
//  LoginView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-08.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State var useremail = ""
    @State var userpassword = ""

    @State var showError : String?
    
    func userlogin() {
        
        if useremail == "" {
            showError = "Enter email"
            return
        }
        
        Auth.auth().signIn(withEmail: useremail, password: userpassword) { authResult, error in
            if error == nil {
                print("Login ok")
            } else {
                print("Login fail")
                showError = "Login error"
            }
        }
    }
    
    func userregister() {
        Auth.auth().createUser(withEmail: useremail, password: userpassword) { authResult, error in
            if error == nil {
                print("Register ok")
            } else {
                print("Register fail")
                showError = error!.localizedDescription
                print(error!.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            
            if showError != nil {
                VStack {
                    Text(showError!)
                }
                .frame(width: 300, height: 100)
                .background(Color.red)
            }
            
            
            TextField("Email", text: $useremail)
            TextField("Password", text: $userpassword)

            Button("Login") {
                userlogin()
            }
            Button("Register") {
                userregister()
            }
            
        }
        
    }
}

#Preview {
    LoginView()
}
