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
    var body: some View {
        VStack {
            Form {
                Section(header: Text("請輸入事件")) {
                    DatePicker("FreeTime", selection: $dd, displayedComponents: .date)
                    
                    Picker(selection: $val1) {
                        ForEach(hours, id: \.self) { hour in
                            Text(hour)
                        }
                    } label: {
                        Text("Start選擇時間（小時）")
                    }
                    
                    Picker(selection: $val2) {
                        ForEach(hours, id: \.self) { hour in
                            Text(hour)
                        }
                    } label: {
                        Text("End選擇時間（小時）")
                    }
                }
            }
            
            Button(action: {
                val = WelcomeView.DateConvertString(date: dd)
                dBHP.AddFreeData(act: val, len: val1, dd: val2)
            }, label: {
                Text("Upload")
            })
            
            Button(action: {
                dBHP.GetFreeTimeData()
            }, label: {
                Text("Get")
            })
        }
    }
}

struct AddFreeTimeView_Previews: PreviewProvider {
    static var previews: some View {
        AddFreeTimeView(dBHP: DBHelper())
    }
}
