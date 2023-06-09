//
//  MainView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 4/29/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct MainView: View {
    @State private var chatId: String = ""
    @Binding var userIsLoggedIn: Bool
    @State private var selection = "Sports"
    @State private var navigateToGroupChat = false
    @State private var showGroupChatView = false
    @State private var isActive: Bool = false
    @StateObject private var navigationHandler = NavigationHandler()
    let topics = ["Sports", "Politics", "Movies", "TV Shows", "Video Games"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background colors from the SignUpView
                Color.white
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.yellow, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 1300, height: 1200)
                    .rotationEffect(.degrees(50))
                    .offset(y: -300)
                
                VStack(spacing: 10) {
                    Text("Welcome, \(Auth.auth().currentUser?.email ?? "N/A")")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(25)
                    
                    
                    VStack {
                        Text("Select a Topic")
                            .font(.title2)
                            .fontWeight(.bold)
                        Picker("Select a Topic", selection: $selection) {
                            ForEach(topics, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 200, height: 140)
                        .clipped()
                        .padding(.bottom)
                        
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.bottom, 15)
                        
                        
                        
                        
                        Button(action: joinGroupChat) {
                            Text("Go to Group Chat")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                                .background(Color.blue)
                                .cornerRadius(50)
                        }
                        .padding(10)
                        
                        
                        Button(action: logout) {
                            Text("Logout")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 30)
                                .background(Color.red)
                                .cornerRadius(50)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .navigationBarTitle("Main View", displayMode: .inline)
                    
                    
                    NavigationLink(destination: WaitingRoomView(), isActive: $isActive) {
                        EmptyView()
                    }
                }
            }
            
        }
        .environmentObject(navigationHandler)

    }
        
        
        
        
        
        func logout() {
            print("Logout button tapped")
            do {
                try Auth.auth().signOut()
                userIsLoggedIn = false
            } catch {
                print("Error signing out:", error.localizedDescription)
            }
        }
        
        func joinGroupChat() {
            // Check if the user is logged in
            guard let currentUser = Auth.auth().currentUser else {
                print("User not logged in")
                return
            }
            
            // Reference to the realtime database
            let dbRef = Database.database().reference()
            
            // Add the current user's selected topic to the database
            dbRef.child("topics").child(selection).child("participants").child(currentUser.uid).setValue(true)
            
            // Query the database for users with the same topic
            dbRef.child("topics").child(selection).child("participants").observeSingleEvent(of: .value) { snapshot in
                var groupMembers: [String] = []
                
                // Add the users' uids to the groupMembers array
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot {
                        groupMembers.append(childSnapshot.key)
                    }
                }
                
                // Remove the current user's UID from the groupMembers array
                if let index = groupMembers.firstIndex(of: currentUser.uid) {
                    groupMembers.remove(at: index)
                }
                
                // If there are at least 3 other users with the same topic, create or join the group chat
                if groupMembers.count >= 3 {
                    let chatId = groupMembers.sorted().joined(separator: "-") + "-" + currentUser.uid
                    navigateToWaitingRoom(chatId: chatId)
                } else {
                    let chatId = groupMembers.sorted().joined(separator: "-") + "-" + currentUser.uid
                    navigateToWaitingRoom(chatId: chatId)
                }
            }
        }
        
        
    func backToMain() {
        isActive = false
        navigationHandler.reset()
    }

        
    func navigateToWaitingRoom(chatId: String) {
        self.navigationHandler.chatId = chatId
        self.navigationHandler.topic = selection
        isActive = true
        }
    }
    
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView(userIsLoggedIn: .constant(true))
                .environmentObject(NavigationHandler())
        }
    }

