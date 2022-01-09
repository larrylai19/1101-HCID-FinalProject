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
            Text("登入帳號")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 30)
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
            Image(systemName: "alarm.fill")
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                .font(.system(size: 100))
                .padding(.bottom, 0)
            Text("歡迎使用時間管理大師")
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                .padding(.top, 10)

            FormFieldView(fieldName: "Email", fieldValue: $email, isSecure: false)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.top, 50)

            
            FormFieldView(fieldName: "Password", fieldValue: $password, isSecure: true)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.top, 30)
            
            Button {
                signInHP.LoginAccount(email: email, password: password)
            } label: {
                Text("Sign In")
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
                    .padding(.top, 70)
            }
            .alert(isPresented: $signInHP.showAlert) { () -> Alert in
                Alert(title: Text("ERROR"), message: Text(signInHP.errMsg))
            }
            
            Spacer()
        }
        .padding(.top, 130)
        .frame(alignment: .center)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
