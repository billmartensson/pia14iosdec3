//
//  ContentView.swift
//  pia14iosdec3
//
//  Created by BillU on 2025-12-03.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
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
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button("DO SAVE") {
                savefb()
            }

            Button("DO LOAD") {
                Task {
                    await loadfb()
                }
            }

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
