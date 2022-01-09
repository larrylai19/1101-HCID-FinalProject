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
            Image(systemName: "person.circle.fill")
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                .font(.system(size: 100))
                .padding(.bottom, 0)
            ZStack {
                Rectangle()
                    .fill(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .frame(width: 300, height: 350)
                    .cornerRadius(15.0)
                    .padding(.top, 0)
                VStack {
                    Text("Hi!")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 30)
                        .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    Text("\(email)")
                        .bold()
                        .padding(.bottom, 30)
                        .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    Button {
                        try! FirebaseManager.shared.auth.signOut()
                        self.isLogin = false
                    } label: {
                        Text("Sign Out")
                            .frame(width: 100, height: 40, alignment: .center)
                            .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .cornerRadius(10.0)
                    }
                    
                }
            }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        }
    }
}
