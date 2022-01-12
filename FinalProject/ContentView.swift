//
//  ContentView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/4.
//

import SwiftUI

extension Color {
    static let theme = Color(red: 82/255, green: 85/255, blue: 123/255)
}

struct ContentView: View {
    @AppStorage("isLogin") var isLogin = false
    @State private var selection = 2
    @ObservedObject var dBHP = DBHelper()
//    {
//        didSet {
//            print("DeBug:\(oldValue)\nd\(dBHP)")
//        }
//    }
    @ObservedObject var viewModel = HomeViewModel()
    let serialQueue1 = DispatchQueue(label: "com.waynestalk.serial")
    var date = Date()
    
    init() {
        serialQueue1.sync {
            self.dBHP.getCount()
            print("Count",dBHP.c)
        }
        self.dBHP.getAllData()
        serialQueue1.sync {
            self.dBHP.GetData()
            print("Count",dBHP.c)
        }
        serialQueue1.sync {
            self.viewModel.all = true
        }
        self.dBHP.getAvaliable()
        
        isLogin = FirebaseManager.shared.auth.currentUser != nil
        //UITabBar.appearance().backgroundColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationView {
            if (isLogin) {
                
                TabView(selection:$selection){
                    DailyScheduleView(dBHP: self.dBHP)
                        .tabItem {
                            Image(systemName: "table.badge.more")
                            Text("Daily")
                                .fontWeight(.bold)
                        }
                        .tag(1)
                    HomeView()
                        .tabItem {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                            Text("Calendar")
                                .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                                .fontWeight(.bold)
                        }
                        .tag(2)
                    PersonView()
                        .tabItem {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                            Text("Person")
                                .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                                .fontWeight(.bold)
                        }
                        .tag(3)
                }
                .accentColor(Color.theme)
            
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
