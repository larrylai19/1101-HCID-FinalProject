//
//  DailyScheduleView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/6.
import SwiftUI
import UserNotifications
var times = ["00:00~01:00","01:00~02:00","02:00~03:00","03:00~04:00","04:00~05:00","05:00~06:00","06:00~07:00","07:00~08:00","08:00~09:00","09:00~10:00","10:00~11:00","11:00~12:00","12:00~13:00","13:00~14:00","14:00~15:00","15:00~16:00","16:00~17:00","17:00~18:00" ,"18:00~19:00","19:00~20:00","20:00~21:00","21:00~22:00","22:00~23:00","23:00~00:00"
]

var todolist =  [String]()
var todotime =  [String]()
var timeindex =  [Int]()
var tt = [String]()
func showToday(today:Date) -> String{
    let dateFormatter3 = DateFormatter()
    dateFormatter3.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter3.string(from: today)
    return dateString
}

func schedule(dbhp:DBHelper,result:Array<(key: Int, value: Int)>,eventsection:inout [Int] ){
    print("result: ",result)
    print("timeindex: ",timeindex)
    for (m , n) in result{
        if m == 2 {
            print("happy")
        }
        for i in timeindex[n]..<timeindex[n]+eventsection[m]{
            for j in 0..<todolist.count{
//                print("todotime[j]",todotime[j].prefix(2))
//                print("String",i)
                if(Int(todotime[j].prefix(2)) == i){
                    todolist[j] = dbhp.userData[m].k
                    break
                }
            }
        }
    }
}

func AvaSection(dbhp:DBHelper,section:inout [Int]){
    section.removeAll()
    print(dbhp.freetime)
    var i = 0
    timeindex.removeAll()
    todotime.removeAll()
    todolist.removeAll()
    while i < 24{
        if(dbhp.freetime[i]){
            var tmp = 0
            var j = 0
            while i+j < 24 {
                if(dbhp.freetime[i+j])
                {
                    tmp+=1
                    todotime.append(times[i+j])
                    todolist.append(" ")
                    if(i+j == 23 && tmp != 0)
                    {
                        timeindex.append(i)
                        section.append(tmp)
                        i = 24
                        break
                    }
                }
                else
                {
                    section.append(tmp)
                    timeindex.append(i)
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
    @State private var showAlert = false
    @State private var alertTitle = "請加入更多空閒時間！"
    var mfc = MaximumFlowClass()
    let serialQueue = DispatchQueue(label: "com.waynestalk.serial")

    var body: some View {
//        VStack{
//            Text(showToday(today:day) + " Schedule")
//                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                .fontWeight(.bold)
//                .font(.system(size: 25))
//            List(times.indices, id: \.self) { idx in
//                HStack{
//                    Text(times[idx])
//                    Spacer()
//                    Text(todolist[idx])
//                    Spacer()
//                }
//            }
////                Button(action: {
////                    EditMode = true
////                }, label: {
////                    Text("Edit")
////                })
//        }
        if(!EditMode){
            VStack{
                Text(showToday(today:day) + " Schedule")
                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .fontWeight(.bold)
                    .font(.system(size: 25))
//                List(dBHP.userData.indices, id: \.self) { idx in
//                    HStack{
//                        Text(todolist[idx])
//                        Spacer()
//
//                        Spacer()
//                    }
//                }
                if(todolist.count != 0){
                    List(todolist.indices, id: \.self) { idx in
                        HStack{
                            Text(todotime[idx])
                            Spacer()
                            Text(todolist[idx])
                            Spacer()
                        }
                    }
                }else{
                    List(times.indices, id: \.self) { idx in
                        HStack{
                            Text(times[idx])
                            Spacer()

                        }
                    }
                }
                Button(action: {
                    EditMode = true
                    dBHP.getAllData()
                }, label: {
                    Text("Edit")
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .navigationBarHidden(true)
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
                                    .foregroundColor(Color(red: 225/255, green: 225/255, blue: 225/255))
                            }
                            else{
                                Text("Free")
                                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
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
                        AvaSection(dbhp: dBHP, section: &emptysection)
                        EventSection(dbhp: dBHP, section: &eventsection)
                        //schedule(dbhp: dBHP, total: &TotalLength)
                        var temp = [Int]()
                        var tp = [Int]()
                        if emptysection.count < eventsection.count{
                            var mx = eventsection.max()!
                            for i in 0..<emptysection.count{
                                var e = emptysection[i]
                                var indextmp = timeindex[i]
                                if(e > mx){
                                    var tmp = e
                                    while tmp > mx{
                                        temp.append(mx)
                                        tp.append(indextmp)
                                        indextmp += mx
                                        tmp -= mx
                                    }
                                    temp.append(tmp)
                                    tp.append(indextmp)
                                }
                                else{
                                    temp.append(e)
                                    tp.append(timeindex[i])
                                }
                            }
                            emptysection = temp
                            timeindex = tp
                        }
                        
                        mfc.setData(activityTime: eventsection, availTime: emptysection)
                        print("activitytime",eventsection)
                        print("availTime",emptysection)
                        mfc.maximumFlow()
                        if mfc.isVaild() {
                            let ret = mfc.getResult()
                            for (i, j) in ret {
                                print("活動 \(i) (\(eventsection[i]) 小時) 對應到空閑時間 \(j) (\(emptysection[j]) 小時)")
                            }
                            schedule(dbhp: dBHP, result: ret, eventsection: &eventsection)
                        }
                        else {
                            showAlert = true
                            print("時間給的不夠，重新輸入")
                        }
                        
                        
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
                            if success {
                                print("all set")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        let ret = mfc.getResult()
                        for (m,n) in ret {
                            let content = UNMutableNotificationContent()
                            content.title = "Time to Working !"
                            content.subtitle = "\(dBHP.userData[m].k) needs to be done."
                            content.sound = UNNotificationSound.default
                            var Today = showToday(today: day)
                            let calendar = Calendar.current
    //                        let components = DateComponents(year: 2022, month: 01, day: 11, hour: 2, minute: 00) // Set the date here when you want Notification
                            var components = DateComponents()
                            let b = Today.split(separator: "-")
                            components.year = Int(b[0])
                            components.month = Int(b[1])
                            components.day = Int(b[2])
                            components.hour = timeindex[n]
                            components.minute = 0
                            let date = calendar.date(from: components)
                            let comp2 = calendar.dateComponents([.year,.month,.day,.hour,.minute], from: date!)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: comp2, repeats: false)
                            let request = UNNotificationRequest(
                                identifier: UUID().uuidString,
                                content: content,
                                trigger: trigger
                            )
                            
                            UNUserNotificationCenter.current().add(request)
                        }
                    }, label: {
                        Text("Schedule")
                    }).alert(alertTitle, isPresented: $showAlert, actions: {
                        Button("OK") { }
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

//struct DailyScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyScheduleView(dBHP: DBHelper())
//    }
//}
