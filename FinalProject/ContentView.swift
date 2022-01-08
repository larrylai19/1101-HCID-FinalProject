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
        //UITabBar.appearance().backgroundColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        UITabBar.appearance().selectedItem?.badgeColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)

    }

    var body: some View {
        NavigationView {
            
            if (isLogin) {
                TabView{
                    DailyView()
                        .tabItem {
                            Image(systemName: "table.badge.more")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                            Text("Daily")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                                .fontWeight(.bold)
                        }
                    HomeView()
                        .tabItem {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                            Text("Calendar")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                                .fontWeight(.bold)
                        }
                    PersonView()
                        .tabItem {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                            Text("Person")
                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                                .fontWeight(.bold)
                        }
                }
            }
            else {
                SignUpView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
