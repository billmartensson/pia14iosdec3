//
//  LoginView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-08.
//

import SwiftUI

struct LoginView: View {
    
    @State var useremail = ""
    @State var userpassword = ""
    
    @State var logincode = LoginCode()
    
    var body: some View {
        VStack {
            
            if logincode.showError != nil {
                VStack {
                    Text(logincode.showError!)
                }
                .frame(width: 300, height: 100)
                .background(Color.red)
            }
            
            
            TextField("Email", text: $useremail)
            TextField("Password", text: $userpassword)

            Button("Login") {
                Task {
                    await logincode.userlogin(useremail: useremail, userpassword: userpassword)
                }
            }
            Button("Register") {
                Task {
                    await logincode.userregister(useremail: useremail, userpassword: userpassword)
                }
            }
            Button("Forgot password") {
                Task {
                    await logincode.forgotpassword(useremail: useremail)
                }
            }

        }
        
    }
}

#Preview {
    LoginView()
}
