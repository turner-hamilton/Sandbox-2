//
//  Sandbox_2App.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 4/27/23.
//

import SwiftUI
import Firebase

struct ParentView: View {
    @State private var isUserLoggedIn = false
    
    var body: some View {
        ContentView(userIsLoggedIn: $isUserLoggedIn)
    }
}


@main
struct Sandbox_2App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ParentView()
        }
    }
}
