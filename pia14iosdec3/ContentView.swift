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

    @State var editshop : ShopItem?
    
    func doedit(item : ShopItem) {
        addname = item.shopname
        addamount = "\(item.shopamount)"
        
        editshop = item
    }
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("Name", text: $addname)
                TextField("Amount", text: $addamount)
                
                Button(editshop == nil ? "ADD" : "SAVE") {
                    shopcode.addToShopping(edititem: editshop, newname: addname, newamount: addamount)
                    
                    editshop = nil
                    addname = ""
                    addamount = ""
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
                        shopcode.switchbought(item: item)
                    }
                }
                .swipeActions(edge: .trailing) {
                    Button("Edit") {
                        doedit(item: item)
                    }
                    .tint(Color.purple)

                    Button("Delete") {
                        shopcode.deleteShopping(deleteitem: item)
                    }
                    .tint(Color.red)

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
