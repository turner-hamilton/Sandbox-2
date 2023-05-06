//
//  GroupChatView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/4/23.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct GroupChatView: View {
    let topic: String
    let chatId: String?
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var email = ""
    @StateObject var messagesManager = MessagesManager()
    @State private var messages: [Message] = []
    @State private var messageToSend: String = ""
    @State private var participantCount: Int = 0
    private let dbRef = Database.database().reference()
    
    var body: some View {
        VStack {
            Text("Topic: \(topic)")
                .font(.title2)

            Button(action: leaveChat) {
                Text("Leave Chat")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
            .padding(.top)

            // Insert the participant count text here
            HStack {
                Text("Participants: \(participantCount)")
                    .font(.caption)
                    .padding(.top)
                    .padding(.leading)

                Spacer()
            }
            // New ScrollView with updated message display logic
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(messages) { message in
                        if message.senderId == Auth.auth().currentUser?.uid {
                            // Message sent by the current user
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        } else {
                            // Message received from other users
                            Text(message.content)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }

            // The rest of the GroupChatView body remains the same
            HStack {
                TextField("Type a message...", text: $messageToSend)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                    .padding(.horizontal)

                Button(action: sendMessage) {
                    Text("Send")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.trailing)
            }
            .padding(.bottom, 8)
        }
        .padding(.horizontal)
        .navigationBarTitle("Group Chat", displayMode: .inline)
        .onAppear {
            fetchMessages()
            fetchParticipantCount()
        }
    }
    
    func leaveChat() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User not logged in")
            return
        }
        
        // Unwrap the chatId safely
        guard let chatId = chatId, !chatId.isEmpty else {
            print("Invalid chatId")
            return
        }

        let dbRef = Database.database().reference()

        // Remove the current user from the participants list in the chat
        dbRef.child("topics").child(chatId).child("participants").child(currentUser.uid).removeValue { error, _ in
            if let error = error {
                print("Error leaving chat:", error.localizedDescription)
            } else {
                // Check if there is only one participant left, and if so, delete the chat data
                dbRef.child("topics").child(chatId).child("participants").observeSingleEvent(of: .value) { snapshot in
                    if snapshot.childrenCount == 1 {
                        dbRef.child("topics").child(chatId).removeValue()
                        dbRef.child("chats").child(chatId).removeValue()
                        print("Chat data deleted")
                    }
                    
                    // Dismiss the GroupChatView and navigate back to MainView
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }




    
    func fetchMessages() {
        dbRef.child("chats/\(chatId)").observe(.childAdded) { snapshot in
            guard let messageData = snapshot.value as? [String: Any],
                  let content = messageData["content"] as? String,
                  let senderId = messageData["senderId"] as? String
            else { return }

            let message = Message(id: snapshot.key, content: content, senderId: senderId)
            messages.append(message)
        }
    }

    func sendMessage() {
        guard !messageToSend.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let currentUser = Auth.auth().currentUser
        else { return }

        let newMessageRef = dbRef.child("chats/\(chatId)").childByAutoId()
        let messageData: [String: Any] = [
            "content": messageToSend,
            "senderId": currentUser.uid
        ]

        newMessageRef.setValue(messageData) { error, _ in
            if let error = error {
                print("Error sending message:", error.localizedDescription)
            } else {
                print("Message sent successfully")
                messageToSend = ""
            }
        }
    }
    func fetchParticipantCount() {
        guard let chatId = chatId, !chatId.isEmpty else {
            print("Invalid chatId")
            return
        }
    }


    
    struct Message: Identifiable {
        let id: String
        let content: String
        let senderId: String
    }

    
    struct GroupChatView_Previews: PreviewProvider {
        static var previews: some View {
            GroupChatView(topic: "Sports", chatId: "sampleChatId")
        }
    }
}
