//
//  SignUpView.swift
//  Sandbox 2
//
//  Created by Turner Hamilton on 5/4/23.
//

import SwiftUI
import Firebase


struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State var signUpMessage = "Sign up"
    @State var viewMessage = "Sign Up"
    @State private var isUserLoggedIn = false
    @EnvironmentObject var navigationHandler: NavigationHandler



    var body: some View {
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
                
                Button {
                    switchToContentView()
                }   label: {
                        Text("Already have an account? Login")
                            .bold()
                            .foregroundColor(.black)
                    }
                    .padding(.top)
                    .offset(y: 110)
                    
                }
                .frame(width: 350)
            }
            .ignoresSafeArea()
        }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in if error != nil {
            print(error!.localizedDescription)
        }
            
        }
    }
    func switchToContentView() {
        let contentView = ContentView(userIsLoggedIn: $isUserLoggedIn)
            .environmentObject(navigationHandler)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: contentView)
            window.makeKeyAndVisible()
        }
    }


}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
