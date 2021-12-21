//
//  MainView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/4.
//

import SwiftUI

class Event: ObservableObject {
    @Published var details = [Detail]()
}

struct Detail: Identifiable {
    let id = UUID()
    let activity:String
    let len:String
    let deadline:String
}

struct MainView: View {
    @StateObject var event = Event()
    @State private var act = ""
    @State private var l = ""
    @State private var dd = ""
    @State private var details = [Detail]()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("請輸入事件")) {
                    TextField("Activity", text:$act)
                    TextField("Length", text: $l)
                        .keyboardType(.numberPad)
                    TextField("DeadLine", text: $dd)
                    Button(
                        action: {
                            let detail = Detail(activity: act, len: l, deadline: dd)
                            event.details.append(detail)
                            print(event.details)
                        }, label: {
                            Text("Add")
                        })
                }
            }
            HStack {

            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
