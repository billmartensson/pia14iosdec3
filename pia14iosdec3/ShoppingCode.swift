//
//  ShoppingCode.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-03.
//

import Foundation
import Firebase
import FirebaseAuth

struct ShopItem {
    var fbid : String
    var shopname: String
    var shopamount: Int
    var shopbought: Bool
}


@Observable class ShoppingCode {
    
    var shoppinglist: [ShopItem] = []
    
    let ref = Database.database().reference()
    
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
    
    
    func addToShopping(edititem : ShopItem?, newname : String, newamount : String) async -> Bool {
        guard let newamountint = Int(newamount) else { return false }
        
        var shopsave = [String : Any]()
        
        shopsave["shopname"] = newname
        shopsave["shopamount"] = newamountint
        if edititem == nil {
            shopsave["shopbought"] = false
        }
        
        let userid = Auth.auth().currentUser!.uid
        
        if edititem == nil {
            do {
                try await ref.child("shoppinglist").child(userid).childByAutoId().setValue(shopsave)
            } catch {
                // FEL VID SPARA
                return false
            }
        } else {
            do {
                try await ref.child("shoppinglist").child(userid).child(edititem!.fbid).updateChildValues(shopsave)
            } catch {
                // FEL VID UPPDATERA
                return false
            }
        }
        
        await loadShopping()
        
        return true
    }
    
    func loadShopping() async -> Bool {

        var loadinglist: [ShopItem] = []

        
        if isPreview {
            let s1 = ShopItem(fbid: "1", shopname: "Apelsin", shopamount: 1, shopbought: false)
            let s2 = ShopItem(fbid: "2", shopname: "Banan", shopamount: 2, shopbought: false)
            let s3 = ShopItem(fbid: "3", shopname: "Citron", shopamount: 3, shopbought: false)

            loadinglist.append(s1)
            loadinglist.append(s2)
            loadinglist.append(s3)
            
            shoppinglist = loadinglist
            return true
        }
        
        do {
            
            let userid = Auth.auth().currentUser!.uid
            
            let snapshot = try await ref.child("shoppinglist").child(userid).getData()
            
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
            return false
        }
        return true
    }
    
    func deleteShopping(deleteitem : ShopItem) {
        let userid = Auth.auth().currentUser!.uid
        
        ref.child("shoppinglist").child(userid).child(deleteitem.fbid).removeValue()
        
        Task {
            await loadShopping()
        }
    }
    
    func switchbought(item : ShopItem) {
        let userid = Auth.auth().currentUser!.uid
        
        let newbought = !item.shopbought

        ref.child("shoppinglist").child(userid).child(item.fbid).child("shopbought").setValue(newbought)
        
        Task {
            await loadShopping()
        }
    }
    
}
