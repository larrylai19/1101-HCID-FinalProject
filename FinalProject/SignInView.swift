//
//  SignInView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/12.
//

import SwiftUI

class SignInHelper: ObservableObject {
    
    @AppStorage("isLogin") var isLogin = false
    
    @Published var showAlert = false
    @Published var errMsg = ""
    
    public func LoginAccount(email: String, password: String) {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { [self] result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.errMsg = "\(err)"
                self.errMsg = self.errMsg.substring(from: self.errMsg.firstIndex(of: "\"")!)
                self.errMsg = self.errMsg.substring(to: self.errMsg.lastIndex(of: "\"")!)
                self.errMsg.remove(at: self.errMsg.startIndex)
                self.showAlert = true
                return
            }
            
            self.isLogin = true
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
        }
    }
}

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    @State var showAlert = false
    
    @ObservedObject var signInHP = SignInHelper()

    var body: some View {
        VStack {
            FormFieldView(fieldName: "Email", fieldValue: $email, isSecure: false)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            FormFieldView(fieldName: "Password", fieldValue: $password, isSecure: true)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Button {
                signInHP.LoginAccount(email: email, password: password)
            } label: {
                Text("Sign In")
            }
            .alert(isPresented: $signInHP.showAlert) { () -> Alert in
                Alert(title: Text("ERROR"), message: Text(signInHP.errMsg))
            }
            
            Spacer()
        }
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
