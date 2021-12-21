//
//  ContentView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/4.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("isLogin") var isLogin = false
    
    init() {
        isLogin = FirebaseManager.shared.auth.currentUser != nil
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if (isLogin) {
                    WelcomeView()
                }
                else {
                    SignUpView()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
