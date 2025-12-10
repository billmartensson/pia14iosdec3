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
    
    @State var loaderror = false
    
    func doedit(item : ShopItem) {
        addname = item.shopname
        addamount = "\(item.shopamount)"
        
        editshop = item
    }
    
    func saveshop() {
        Task {
            let saveresult = await shopcode.addToShopping(edititem: editshop, newname: addname, newamount: addamount)
            
            if saveresult == true {
                editshop = nil
                addname = ""
                addamount = ""
            } else {
                print("SAVE FAIL!!!")
            }
            
        }
    }
    
    func loadshop() {
        Task {
            let loadresult = await shopcode.loadShopping()
            if loadresult == false {
                loaderror = true
            } else {
                loaderror = false
            }
        }
    }
    
    var body: some View {
        VStack {
            
            HStack {
                TextField("Name", text: $addname)
                TextField("Amount", text: $addamount)
                
                Button(editshop == nil ? "ADD" : "SAVE") {
                    saveshop()
                }
            }
            
            if loaderror {
                VStack {
                    Text("LOAD FAIL")
                    Button("Retry") {
                        loadshop()
                    }
                }
                .frame(width: 300, height: 100)
                .background(Color.red)
            }
            
            List(shopcode.shoppinglist, id: \.fbid) { item in
                HStack {
                    VStack {
                        Text(item.shopname)
                        Text("\(item.shopamount)")
                    }
                    
                    Spacer()
                    
                    Button(item.shopbought ? "KÖPT" : "EJ KÖPT") {
                        if item.fbid == editshop?.fbid {
                            editshop = nil
                            addname = ""
                            addamount = ""
                        } else {
                            shopcode.switchbought(item: item)
                        }
                        
                    }
                }
                .background(item.fbid == editshop?.fbid ? Color.yellow : Color.clear)
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
            loadshop()
        }
    }
}

#Preview {
    ContentView()
}
