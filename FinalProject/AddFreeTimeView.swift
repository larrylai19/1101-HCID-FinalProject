//
//  AddFreeTimeView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/9.
//

import SwiftUI

struct AddFreeTimeView: View {
    var dBHP:DBHelper
    @State var key = "Activity"
    @State var val = ""
    @State var key1 = "Length"
    @State var val1 = ""
    @State var key2 = "DeadLine"
    @State var val2 = ""
    @State var dd = Date()
    let hours = [
        "00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00",
        "13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00",
    ]
    
//    init(){
//        UITableView.appearance().backgroundColor = .white
//    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Input Free Time")
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                .bold()
                .font(.system(size: 30))
                .padding(.top, 100)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Form {
                DatePicker("FreeTime", selection: $dd, displayedComponents: .date)
                    .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
                Picker(selection: $val1) {
                    ForEach(hours, id: \.self) { hour in
                        Text(hour)
                    }
                } label: {
                    Text("Start Time")
                    .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
                }
                
                Picker(selection: $val2) {
                    ForEach(hours, id: \.self) { hour in
                        Text(hour)
                    }
                } label: {
                    Text("End Time")
                    .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
                }
                
            }
            .background(Color.white)
            .onAppear { // ADD THESE
                UITableView.appearance().backgroundColor = .clear
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.top, 100)
            
            Button(action: {
                val = WelcomeView.DateConvertString(date: dd)
                dBHP.AddFreeData(act: val, len: val1, dd: val2)
            }, label: {
                Text("Upload")
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
            })
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.top, 0)
            
//            NavigationLink {
//                ContentView()
//            } label: {
//
//            }
            
//            Button(action: {
//                dBHP.GetFreeTimeData()
//            }, label: {
//                Text("Get")
//                    .frame(width: 100, height: 40, alignment: .center)
//                    .background(Color(red: 82/255, green: 85/255, blue: 123/255))
//                    .font(.system(size: 18))
//                    .foregroundColor(.white)
//                    .cornerRadius(10.0)
//            })
//            .frame(maxHeight: .infinity, alignment: .center)
//            .padding(.top, 0)
        }
    }
}

struct AddFreeTimeView_Previews: PreviewProvider {
    static var previews: some View {
        AddFreeTimeView(dBHP: DBHelper())
    }
}
