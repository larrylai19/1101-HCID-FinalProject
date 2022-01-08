//
//  DailyScheduleView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/6.
import SwiftUI
var times = ["00:00~01:00","01:00~02:00","02:00~03:00","03:00~04:00","04:00~05:00","05:00~06:00","06:00~07:00","07:00~08:00","08:00~09:00","09:00~10:00","10:00~11:00","11:00~12:00","12:00~13:00","13:00~14:00","14:00~15:00","15:00~16:00","16:00~17:00","17:00~18:00" ,"18:00~19:00","19:00~20:00","20:00~21:00","21:00~22:00","22:00~23:00","23:00~00:00"
]

var todolist = [" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "]
//var avaliable = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]

func showToday(today:Date) -> String{
    let dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter3.string(from: today)
    return dateString
}

func schedule(dbhp:DBHelper,total:inout Int){
    for j in 0..<todolist.count{
        for i in 0..<dbhp.userData.count{
            if(dbhp.freetime[j] && total > 0){
               //print(dbhp.userData[i].k)
                todolist[j] = dbhp.userData[i].k
                total-=1
                break
            }else{
                todolist[j] = " "
            }
        }
    }
}

func AvaSection(dbhp:DBHelper,section:inout [Int]){
    section.removeAll()
    print(dbhp.freetime)
    var i = 0
    while i < 24{
        if(dbhp.freetime[i]){
            var tmp = 0
            var j = 0
            while i+j < 24 {
                if(dbhp.freetime[i+j])
                {
                    tmp+=1
                    if(i+j == 23 && tmp != 0)
                    {
                        section.append(tmp)
                        i = 24
                        break
                    }
                }
                else
                {
                    section.append(tmp)
                    i = j + i
                    break
                }
                
                j+=1
            }
        }
        
        i+=1
    }
}

func EventSection(dbhp:DBHelper,section:inout [Int]){
    section.removeAll()
    for i in 0..<dbhp.userData.count{
        section.append(Int(dbhp.userData[i].v) ?? 0)
    }
    print(section)
}



struct DailyScheduleView: View {
    var day = Date()
    var dBHP:DBHelper
    @State var EditMode = false
    @State var TotalLength = 0
    @State var emptysection = [Int]()
    @State var eventsection = [Int]()
    var mfc = MaximumFlowClass()
    let serialQueue = DispatchQueue(label: "com.waynestalk.serial")
    var body: some View {
        Text("今天日程"+showToday(today:day))
        if(!EditMode){
            VStack{
                List(times.indices, id: \.self) { idx in
                    HStack{
                        Text(times[idx])
                        Spacer()
                        Text(todolist[idx])
                        Spacer()
                    }
                }
                HStack{
                    //進入編輯模式
                    Button(action: {
                        EditMode = true
                    }, label: {
                        Text("Edit")
                    })
                }
            }
        }
        else{
            VStack{
                List(times.indices, id: \.self) { idx in
                    HStack{
                        Text(times[idx])
                        Spacer()
                        Button(action: {
                            print(self.dBHP.avaliable)
                            if(!self.dBHP.freetime[idx]){
                                self.dBHP.freetime[idx] = true
                                self.dBHP.avaliable[times[idx]] = true
                            }
                            else{
                                self.dBHP.freetime[idx] = false
                                self.dBHP.avaliable[times[idx]] = false
                            }
                            print(self.dBHP.avaliable)
                        }, label: {
                            if(!self.dBHP.freetime[idx]){
                                Text("Rest")
                            }
                            else{
                                Text("Free")
                            }
                        })
                    }
                }
                
                HStack{
                    Button(action: {
                       EditMode = false
                        serialQueue.sync {
                            self.dBHP.getAvaliable()
                        }
                        
                        serialQueue.sync {
                            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                            FirebaseManager.shared.firestore.collection("users")
                                .document(uid).collection("events").document("avaliable").setData(self.dBHP.avaliable) { [self] err in
                                    if let err = err {
                                        print(err)
                                        return
                                    }
                                }
                        }
                        
                    }, label: {
                        Text("Done")
                    })
                    
                    //進行排程
                    Button(action: {
                        for i in 0..<dBHP.freetime.count{
                            if(dBHP.freetime[i]){
                                TotalLength+=1
                            }
                        }
                        AvaSection(dbhp: dBHP, section: &emptysection)
                        EventSection(dbhp: dBHP, section: &eventsection)
                        //schedule(dbhp: dBHP, total: &TotalLength)
                        mfc.setData(activityTime: eventsection, availTime: emptysection)
                        print("activitytime",eventsection)
                        print("availTime",emptysection)
                        mfc.maximumFlow()
                        if mfc.isVaild() {
                            let ret = mfc.getResult()
                            for (i, j) in ret {
                                print("活動 \(i) (\(eventsection[i]) 小時) 對應到空閑時間 \(j) (\(emptysection[j]) 小時)")
                            }
                        }
                        else {
                            print("時間給的不夠，重新輸入")
                        }
                        
                    }, label: {
                        Text("Schedule")
                    })
                }
            }
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView(dBHP: DBHelper())
    }
}
