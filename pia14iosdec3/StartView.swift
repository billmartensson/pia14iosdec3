//
//  StartView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-08.
//

import SwiftUI
import FirebaseAuth

struct StartView: View {
    
    @State var isLoggedin : Bool?
    
    func listenauth() {
        Auth.auth().addStateDidChangeListener { auth, user in
            print("AUTH LISTEN")
            print(user)
            
            if user == nil {
                isLoggedin = false
            } else {
                isLoggedin = true
            }
        }
    }
    
    var body: some View {
        VStack {
            
            if isLoggedin == true {
                ContentView()
            }
            if isLoggedin == false {
                LoginView()
            }
            
            
        }
        .onAppear() {
            listenauth()
        }
    }
    
    
}

#Preview {
    StartView()
}
