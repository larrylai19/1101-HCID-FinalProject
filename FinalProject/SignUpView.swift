//
//  SignUpView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/12.
//

import SwiftUI

class SignUpHelper: ObservableObject {
    
    @AppStorage("isLogin") var isLogin = false
    
    @Published var showAlert = false
    @Published var errMsg = ""
    
    public func CreateNewAccount(email: String, password: String) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.errMsg = "\(err)"
                self.errMsg = self.errMsg.substring(from: self.errMsg.firstIndex(of: "\"")!)
                self.errMsg = self.errMsg.substring(to: self.errMsg.lastIndex(of: "\"")!)
                self.errMsg.remove(at: self.errMsg.startIndex)
                self.showAlert = true
                return
            }
            
            self.isLogin = true
            print("Successfully created user: \(result?.user.uid ?? "")")
        }
    }
}

struct SignUpView: View {
    
    @ObservedObject private var userRegistrationViewModel = UserRegistrationViewModel()
    @ObservedObject var signUpHP = SignUpHelper()
    
    var body: some View {
        VStack {
            Text("建立帳號")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 30)
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
          
            FormFieldView(fieldName: "Email",
                          fieldValue: $userRegistrationViewModel.username,
                          isSecure: false)
                .keyboardType(.emailAddress)
                .disableAutocorrection(false)
                .autocapitalization(.none)
        
            FormFieldView(fieldName: "Password", fieldValue: $userRegistrationViewModel.password, isSecure: true)
            
            VStack {
                RequirementTextView(
                    iconName: userRegistrationViewModel.isPasswordLengthValid ? "lock.open" : "lock",
                    iconColor: userRegistrationViewModel.isPasswordLengthValid ? Color.green : Color(red: 82/255, green: 85/255, blue: 123/255),
                    text: "至少需有8個字元",
                    isStrikeThrough: userRegistrationViewModel.isPasswordLengthValid
                )
                    .padding(.vertical,5)
                
                RequirementTextView(
                    iconName: userRegistrationViewModel.isPasswordCapitalLetter ? "lock.open" : "lock",
                    iconColor: userRegistrationViewModel.isPasswordCapitalLetter ?  Color.green : Color(red: 82/255, green: 85/255, blue: 123/255),
                    text: "至少需有1個大寫字元",
                    isStrikeThrough: userRegistrationViewModel.isPasswordCapitalLetter
                )
            }
            .padding()
            
            
            FormFieldView(fieldName: "Confirm Password", fieldValue: $userRegistrationViewModel.passwordConfirm,
                          isSecure: true)
            
            RequirementTextView(
                iconName: userRegistrationViewModel.isPasswordConfirmValid ? "lock.open" : "lock",
                iconColor:userRegistrationViewModel.isPasswordConfirmValid ? Color.green  : Color(red: 82/255, green: 85/255, blue: 123/255),
                text: "請再輸入一次相同的密碼",
                isStrikeThrough: userRegistrationViewModel.isPasswordConfirmValid)
                .padding()
                .padding(.bottom, 50)
            
            if CheckVaild() {
                Button(action: {
                    signUpHP.CreateNewAccount(email: userRegistrationViewModel.username, password: userRegistrationViewModel.password)
                }) {
                    Text("Sign Up")
                        .font(.body)
                        .bold()
                        .foregroundColor(Color(red: 251/255, green: 128/255, blue: 128/255))
                }
                .alert(isPresented: $signUpHP.showAlert) { () -> Alert in
                    Alert(title: Text("ERROR"), message: Text(signUpHP.errMsg))
                }
            }
            else {
                Text("Sign Up")
                    .font(.body)
                    .bold()
                    .foregroundColor(.gray)
            }
            
            HStack {
                Text("Already have an account?")
                    .font(.body)
                    .bold()
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("Sign in")
                        .font(.body)
                        .bold()
                        .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                }
            }.padding(.top, 50)
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
    
    private func CheckVaild() -> Bool {
        return userRegistrationViewModel.isPasswordLengthValid &&
        userRegistrationViewModel.isPasswordCapitalLetter &&
        userRegistrationViewModel.isPasswordConfirmValid
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
