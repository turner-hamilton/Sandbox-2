//
//  SignUpView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/4/23.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State private var showLoginView = false
    @State private var email = ""
    @State private var password = ""
    @State var signUpMessage = "Sign up"
    @State var viewMessage = "Sign Up"
    @Binding var userIsLoggedIn: Bool
    @EnvironmentObject var navigationHandler: NavigationHandler

    init(userIsLoggedIn: Binding<Bool>) {
        self._userIsLoggedIn = userIsLoggedIn
    }


    var body: some View {
        NavigationView {
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
                        .offset(x: -110, y: -100)
                    
                    TextField("Email", text: $email)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .background(email.isEmpty ? Text("Email").foregroundColor(.black).bold() : nil)
                    
                        .foregroundColor(.black)
                    
                    
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.black)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.black)
                        .textFieldStyle(.plain)
                        .background(password.isEmpty ? Text("Password").foregroundColor(.black).bold() : nil)
                        .foregroundColor(.black)
                    
                    
                    
                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundColor(.black)
                    
                    Button {
                        register()
                    } label: {
                        Text(signUpMessage)
                            .bold()
                            .frame(width: 200, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.linearGradient(colors: [.yellow], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .offset(y: 50)
                    
                    NavigationLink(destination: LoginView(userIsLoggedIn: $userIsLoggedIn), isActive: $showLoginView) {
                        Button {
                            showLogin()
                        } label: {
                            Text("Already have an account? Login")
                                .bold()
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top)
                    .offset(y: 110)
                    
                    
                }
                .frame(width: 350)
            }
            .ignoresSafeArea()
        }
    }
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in if error != nil {
            print(error!.localizedDescription)
        }
            
        }
    }
    func showLogin() {
        showLoginView.toggle()
    }



}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(userIsLoggedIn: .constant(false))
    }
}
