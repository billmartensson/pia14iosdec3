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

    
    
    
    func userlogin() {
        Auth.auth().signIn(withEmail: useremail, password: userpassword) { authResult, error in
            if error == nil {
                print("Login ok")
            } else {
                print("Login fail")
            }
        }
    }
    
    func userregister() {
        Auth.auth().createUser(withEmail: useremail, password: userpassword) { authResult, error in
            if error == nil {
                print("Register ok")
            } else {
                print("Register fail")
            }
        }
    }
    
    var body: some View {
        VStack {
            
            if Auth.auth().currentUser == nil {
                Text("INTE INLOGGAD")
            }
            if Auth.auth().currentUser != nil {
                Text("INLOGGAD")
                Text(Auth.auth().currentUser!.uid)
            }

            
            
            TextField("Email", text: $useremail)
            TextField("Password", text: $userpassword)

            Button("Login") {
                userlogin()
            }
            Button("Register") {
                userregister()
            }
            
            Button("LOGOUT") {
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
            }
            
        }
        
    }
}

#Preview {
    LoginView()
}
