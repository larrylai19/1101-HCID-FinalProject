//
//  DailyScheduleView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/6.
//

import SwiftUI
var times = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00","14:00","15:00","16:00","17:00","18:00","19:00","20:00","21:00","22:00","23:00"]

//var avaliable = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]

//func showToday(today:Date) -> String{
//    let dateFormatter3 = DateFormatter()
//    dateFormatter3.dateFormat = "yyyy-MM-dd"
//    let dateString = dateFormatter3.string(from: today)
//    return dateString
//}



struct DailyScheduleView: View {
    var day = Date()
    var dBHP:DBHelper
    @State var EditMode = false
    var body: some View {
        if(!EditMode){
            VStack{
                List(times.indices, id: \.self) { idx in
                    HStack{
                        Text(times[idx])
                        Spacer()
                        if(dBHP.freetime[idx])
                        {
                            Text("Free")
                        }else
                        {
                            Text("Rest")
                        }
                    }
                }
                
                Button(action: {
                    EditMode = true
                }, label: {
                    Text("Edit")
                })
            }
        }
        else{
            VStack{
                List(times.indices, id: \.self) { idx in
                    HStack{
                        Text(times[idx])
                        Spacer()
                        Button(action: {
                            if(!dBHP.freetime[idx]){
                                dBHP.freetime[idx] = true
                                self.dBHP.avaliable[times[idx]] = true
                            }
                            else{
                                dBHP.freetime[idx] = false
                                self.dBHP.avaliable[times[idx]] = false
                            }
                            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                            FirebaseManager.shared.firestore.collection("users")
                                .document(uid).collection("events").document("avaliable").setData(self.dBHP.avaliable) { [self] err in
                                    if let err = err {
                                        print(err)
                                        return
                                    }
                                }
                        }, label: {
                            if(!dBHP.freetime[idx]){
                                Text("Rest")
                            }
                            else{
                                Text("Free")
                            }
                        })
                    }
                }
                
                Button(action: {
                   EditMode = false
                }, label: {
                    Text("Done")
                })
            }
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView(dBHP: DBHelper())
    }
}
