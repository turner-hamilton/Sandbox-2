//
//  NavigationHandler.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/9/23.
//

import SwiftUI
import FirebaseDatabase

class NavigationHandler: ObservableObject {
    @Published var navigateToGroupChat: Bool = false
    @Published var chatId: String = ""
    @Published var numberOfParticipants: Int = 0
    @Published var topic: String = ""
    var hasEventListener: Bool = false
    
    func resetNavigation() {
        navigateToGroupChat = false
        chatId = ""
    }
    
    func listenToChatUpdates(chatId: String, completion: @escaping () -> Void) {
        let dbRef = Database.database().reference()
        dbRef.child("topics").child(chatId).child("participants").observe(.value) { snapshot in
            if let participants = snapshot.value as? [String] {
                self.numberOfParticipants = participants.count
                completion()
            }
        }
        hasEventListener = true
    }
}




struct NavigationHandlerModifier: ViewModifier {
    @EnvironmentObject var navigationHandler: NavigationHandler
    
    func body(content: Content) -> some View {
        content
            .background(GroupChatNavigationLink())
    }
    
    struct GroupChatNavigationLink: View {
        @EnvironmentObject var navigationHandler: NavigationHandler

        var body: some View {
            NavigationLink(destination: GroupChatView(topic: navigationHandler.topic, chatId: navigationHandler.chatId).navigationBarBackButtonHidden(true),
                           isActive: $navigationHandler.navigateToGroupChat) {
                EmptyView()
            }
            .hidden()
        }
    }
}

extension View {
    func handleNavigation(handler: NavigationHandler) -> some View {
        self.modifier(NavigationHandlerModifier()).environmentObject(handler)
    }
}
