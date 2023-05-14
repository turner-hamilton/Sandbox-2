//
//  WaitingRoomView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/9/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct WaitingRoomView: View {
    @EnvironmentObject var navigationHandler: NavigationHandler
    var topic: String { navigationHandler.topic }
    var chatId: String { navigationHandler.chatId }
    @Environment(\.dismiss) var dismiss
    @State private var navigateToGroupChat = false
    @State private var participantCount = 0
    
    func navigateToMainView() {
        navigateToView(MainView(userIsLoggedIn: .constant(true)))
    }
    
    func navigateToView<Content: View>(_ view: Content) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: view)
            window.makeKeyAndVisible()
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Waiting for more participants...")
                .font(.title)
                .fontWeight(.bold)
                .padding(25)
            
            Text("Topic: \(topic)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Participants: \(participantCount)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 50)
        }
        .onAppear(perform: setupListeners)
        .sheet(isPresented: $navigateToGroupChat) {
            GroupChatView(backToMain: navigateToMainView, navigationHandler: navigationHandler, showGroupChatView: $navigationHandler.showGroupChatView)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigationHandler)
        }
    }
    
    func setupListeners() {
        // Reference to the realtime database
        let dbRef = Database.database().reference()
        
        // Listen for the participant count change
        observeParticipantCount(dbRef: dbRef)
    }
    
    private func observeParticipantCount(dbRef: DatabaseReference) {
        dbRef.child("topics").child(topic).child("participants").observe(.value) { snapshot in
            if let participants = snapshot.value as? [String: Bool] {
                participantCount = participants.count
                if participantCount == 4 {
                    // If there are 4 participants, navigate to the group chat
                    navigateToGroupChat = true
                }
            }
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView()
            .environmentObject(NavigationHandler())
    }
}
