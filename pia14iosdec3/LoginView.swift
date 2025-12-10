//
//  LoginView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-08.
//

import SwiftUI

struct LoginView: View {
    
    enum TheActivateFieldNow {
        case email, password
    }
    
    @State var useremail = ""
    @State var userpassword = ""
    
    @State var logincode = LoginCode()
    
    @FocusState private var focusedField: TheActivateFieldNow?
        
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                VStack {
                }
                .frame(width: 300, height: 5)
                .background(Color.red)
                
                Text("\(geometry.size.height)")
                                
                Spacer()
                
                if logincode.showError != nil {
                    VStack {
                        Text(logincode.showError!)
                    }
                    .frame(width: 300, height: 100)
                    .background(.red)
                }
                
                VStack {
                }
                .frame(width: 300, height: focusedField == nil ? 200 : 100)
                .background(Color.cyan)
                
                Text("Email")
                    .font(focusedField == .email ? Font.title3.bold() : Font.title3)
                TextField("Email", text: $useremail)
                    .border(focusedField == .email ? .black : .clear)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .submitLabel(.next)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        print("EMAIL SUBMIT")
                        focusedField = .password
                    }
                
                Text("Password")
                    .font(focusedField == .password ? Font.title3.bold() : Font.title3)
                SecureField("Password", text: $userpassword)
                    .border(focusedField == .password ? .black : .clear)
                    .padding(.horizontal)
                    .submitLabel(.send)
                    .keyboardType(.default)
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        print("PASSWORD SUBMIT")
                        Task {
                            await logincode.userlogin(useremail: useremail, userpassword: userpassword)
                        }
                    }

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
                
                Spacer()
                
                VStack {
                }
                .frame(width: 300, height: 5)
                .background(Color.blue)
                
            }
            .onTapGesture {
                print("TAP TAP")
                focusedField = nil
            }

        }

    }
}

#Preview {
    LoginView()
}
