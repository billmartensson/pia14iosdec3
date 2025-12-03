//
//  ShoppingCode.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-03.
//

import Foundation
import Firebase


struct ShopItem {
    var fbid : String
    var shopname: String
    var shopamount: Int
    var shopbought: Bool
}


@Observable class ShoppingCode {
    
    var shoppinglist: [ShopItem] = []
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    func savefb() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("fruit").setValue("apelsin")
        
    }
    
    func loadfb() async {
        var ref: DatabaseReference!
        ref = Database.database().reference()

        do {
            let snapshot = try await ref.child("fruit").getData()
            
            let fruittext = snapshot.value as! String
            
            print(fruittext)
            
        } catch {
            print("ERROR FEL!!")
        }
        
    }
    
    
    func addToShopping(newname : String, newamount : String) {
        guard let newamountint = Int(newamount) else { return }
        
        var ref = Database.database().reference()
        
        var shopsave = [String : Any]()
        
        shopsave["shopname"] = newname
        shopsave["shopamount"] = newamountint
        shopsave["shopbought"] = false

        
        ref.child("shoppinglist").childByAutoId().setValue(shopsave)
        Task {
            await loadShopping()
        }
    }
    
    func loadShopping() async {

        var loadinglist: [ShopItem] = []

        if isPreview {
            let s1 = ShopItem(fbid: "1", shopname: "Apelsin", shopamount: 1, shopbought: false)
            let s2 = ShopItem(fbid: "2", shopname: "Banan", shopamount: 2, shopbought: false)
            let s3 = ShopItem(fbid: "3", shopname: "Citron", shopamount: 3, shopbought: false)

            loadinglist.append(s1)
            loadinglist.append(s2)
            loadinglist.append(s3)
            
            shoppinglist = loadinglist
            return
        }
        
        var ref = Database.database().reference()
        
        do {
            let snapshot = try await ref.child("shoppinglist").getData()
            
            snapshot.children.forEach { (child) in
                let childsnapshot = child as! DataSnapshot
                                
                let shopdata = childsnapshot.value as! [String : Any]
                
                let shopthing = ShopItem(
                    fbid: childsnapshot.key,
                    shopname: shopdata["shopname"] as! String,
                    shopamount: shopdata["shopamount"] as! Int,
                    shopbought: shopdata["shopbought"] as! Bool
                )
                
                loadinglist.append(shopthing)
            }
                     
            shoppinglist = loadinglist
        } catch {
            print("ERROR FEL!!")
        }
    }
    
    func deleteShopping(deleteitem : ShopItem) {
        var ref = Database.database().reference()
        
        ref.child("shoppinglist").child(deleteitem.fbid).removeValue()
        
        Task {
            await loadShopping()
        }
    }
    
}
