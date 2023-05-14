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
    @Published var showGroupChatView: Bool = false // Add this line
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

    func navigateToMainView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let navigationHandler = NavigationHandler()
            let rootView = MainView(userIsLoggedIn: .constant(true)).environmentObject(navigationHandler)
            window.rootViewController = UIHostingController(rootView: rootView)
            window.makeKeyAndVisible()

        }
    }

    func body(content: Content) -> some View {
        content
            .background(GroupChatNavigationLink(navigateToMainView: navigateToMainView))
    }
    
    struct GroupChatNavigationLink: View {
        @EnvironmentObject var navigationHandler: NavigationHandler
        let navigateToMainView: () -> Void

        var body: some View {
            NavigationLink(destination: GroupChatView(backToMain: navigateToMainView, navigationHandler: navigationHandler, showGroupChatView: $navigationHandler.showGroupChatView).navigationBarBackButtonHidden(true),
                           isActive: $navigationHandler.navigateToGroupChat) {
                EmptyView()
            }
            .hidden()
        }
    }
}





