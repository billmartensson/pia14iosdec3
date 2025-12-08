//
//  ContentView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-03.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @State var shopcode = ShoppingCode()
    
    @State var addname = ""
    @State var addamount = ""

    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            HStack {
                TextField("Name", text: $addname)
                TextField("Amount", text: $addamount)
                
                Button("ADD") {
                    shopcode.addToShopping(newname: addname, newamount: addamount)
                }
            }
            
            List(shopcode.shoppinglist, id: \.fbid) { item in
                HStack {
                    VStack {
                        Text(item.shopname)
                        Text("\(item.shopamount)")
                    }
                    
                    Spacer()
                    
                    Button(item.shopbought ? "KÖPT" : "EJ KÖPT") {
                        
                    }

                    Button("DELETE") {
                        shopcode.deleteShopping(deleteitem: item)
                    }
                }
            }
            
            Button("Logout") {
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
            }
            
        }
        .padding()
        .task {
            await shopcode.loadShopping()
        }
    }
}

#Preview {
    ContentView()
}
