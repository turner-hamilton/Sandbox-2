//
//  ContentView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 4/27/23.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var userIsLoggedIn: Bool
    @State var viewMessage = "Log In"
    @State var loginMessage = "Log In"
    var handle: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        if userIsLoggedIn {
            MainView(userIsLoggedIn: $userIsLoggedIn)
                .onDisappear {
                    if let handle = handle {
                        Auth.auth().removeStateDidChangeListener(handle)
                    }
                }
        } else {
            content
        }
    }

    
    var content: some View {
        
        ZStack {
            Color.white
            
            RoundedRectangle(cornerRadius: 0, style: .continuous).foregroundStyle(.linearGradient(colors: [.yellow, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1300, height: 1200)
                .rotationEffect(.degrees(50))
                .offset(y: -300)
            
            
            VStack(spacing:20) {
                Text(viewMessage)
                    .foregroundColor(.black)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -116, y: -100)
                
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.black)
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty) {
                        Text("Password")
                            .foregroundColor(.black)
                            .bold()
                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.black)
                
                Button {
                    login()
                } label: {
                    Text(loginMessage)
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.linearGradient(colors: [.yellow], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.black)
                }
                .padding(.top)
                .offset(y: 50)
                
                Button {
                    signUpView()
                } label: {
                    Text("Don't have an account? Sign up")
                        .bold()
                        .foregroundColor(.black)
                }
                .padding(.top)
                .offset(y: 110)
                
                
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        self.userIsLoggedIn = true
                    }
                }
            }
            .onDisappear {
                if let handle = handle {
                    Auth.auth().removeStateDidChangeListener(handle)
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                userIsLoggedIn = true
            }
        }
    }
    
    func signUpView() {
        let signUpView = SignUpView()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: signUpView)
            window.makeKeyAndVisible()
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userIsLoggedIn: .constant(false)) // bind to a boolean variable
    }
}

    
    extension View {
        func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {
                
                ZStack(alignment: alignment) {
                    placeholder().opacity(shouldShow ? 1 : 0)
                    self
                }
            }
    }

