//
//  PersonView.swift
//  FinalProject
//
//  Created by Isadora Lo on 2022/1/9.
//

import SwiftUI

struct PersonView: View {
    @AppStorage("isLogin") var isLogin = false
    var uid = FirebaseManager.shared.auth.currentUser != nil ? FirebaseManager.shared.auth.currentUser?.uid as! String : ""
    var email = FirebaseManager.shared.auth.currentUser?.email as! String
    
    var body: some View {
        VStack {
            Text("Hi~")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 30)
            Text("\(email)")
                .bold()
                .padding(.bottom, 30)
            Button {
                try! FirebaseManager.shared.auth.signOut()
                self.isLogin = false
            } label: {
                Text("Sign Out")
                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
            }
        }
    }
}
