//
//  WelcomeView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/12.
//

import SwiftUI
struct DataDetail{
    var k = ""
    var v = ""
    var l = ""
}

class DBHelper: ObservableObject {
    @Published var userData = [DataDetail]()
    @Published var errMsg: String? = nil
    @Published var uploadData = [String: Any]()
    @Published var Count = [String: Any]()
    @Published var c:Int = 0 {
        willSet {
            print("old: \(c), new: \(newValue)")
        }
    }
    
    var firstGetData = false
    
    public func getCount() {

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).collection("events").document("count").getDocument { snapshot, err in
            if let err = err {
                print("Failed: \(err)")
                self.errMsg = "\(err)"
                return
            }
            
            
            guard let count = snapshot?.data() else {
                print("No count found")
                self.errMsg = "No data found"
                self.firstGetData = true
                self.Count["count"] = "0"
                FirebaseManager.shared.firestore.collection("users")
                    .document(uid).collection("events").document("count").setData(self.Count) { [self] err in
                        if let err = err {
                            print(err)
                            return
                        }
                    }
                return
            }
            self.c = Int(count["count"] as! String) ?? 0
            print(self.c)
        }
    }
    
    public func GetData() {
//        getCount()
        print("GETDATA(C): \(self.c)")
        self.errMsg = nil
        self.userData.removeAll()
        self.uploadData.removeAll()
        self.Count.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        for index in 0...self.c {
                FirebaseManager.shared.firestore.collection("users").document(uid).collection("events").document("event"+String(index)).getDocument { snapshot, err in
                    if let err = err {
                        print("Failed: \(err)")
                        self.errMsg = "\(err)"
                        return
                    }


                    guard let data = snapshot?.data() else {
                        print("No data found")
                        self.errMsg = "No data found"
                        self.firstGetData = true
                        return
                    }
//                    print(data)
//                    for e in data {
//                        self.userData.append(DataDetail(k: e.key, v: "\(e.value)"))
//                        self.uploadData[e.key] = e.value as! String
//                    }
                    self.userData.append(DataDetail(k: data["Activity"] as! String, v: data["Lengh"] as! String , l:data["DeadLine"] as! String))
//                    print(self.userData)
                    self.firstGetData = true
                }
        }
        self.firstGetData = true
    }
    
    public func AddData(act: String, len: String, dd:String ) {
        getCount()
        self.errMsg = nil
        if self.firstGetData == false {
            self.errMsg = "Get data first!"
            print("ERR")
            return
        }

        if act.isEmpty || len.isEmpty {
            self.errMsg = "key or val is empty!"
            return
        }

        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        if self.uploadData["event"+String(self.c)] == nil {
            self.userData.append(DataDetail(k: act, v: len , l:dd))
        }

        self.uploadData["Activity"] = act
        self.uploadData["Lengh"] = len
        self.uploadData["DeadLine"] = dd
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).collection("events").document("event"+String(self.c)).setData(self.uploadData) { [self] err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success add data")
            }
        self.c += 1
        self.Count["count"] = String(self.c)
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).collection("events").document("count").setData(self.Count) { [self] err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success add data \"num\": \"\(c)\"")
            }
    }
    
    public func DeleteData() {
        let cl = ["count": "0"]
        getCount()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        self.userData.removeAll()
        
        for i in 0...self.c{
        FirebaseManager.shared.firestore.collection("users")
                .document(uid).collection("events").document("event"+String(i)).delete()
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).collection("events").document("count").setData(cl) { [self] err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success delete events")
            }
    }
}



struct WelcomeView: View {
    @AppStorage("isLogin") var isLogin = false
    var uid = FirebaseManager.shared.auth.currentUser != nil ? FirebaseManager.shared.auth.currentUser?.uid as! String : ""
    var email = FirebaseManager.shared.auth.currentUser?.email as! String

    @ObservedObject var dBHP: DBHelper
    @State var key = "Activity"
    @State var val = ""
    @State var key1 = "Length"
    @State var val1 = ""
    @State var key2 = "DeadLine"
    @State var val2 = ""
    @State var dd = Date()
    let hours = [
        "1","2","3","4","5","6","7","8","9","10","11","12"
    ]
    
    static func DateConvertString(date:Date,dateFormat:String="yyyy-MM-dd") ->String{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "Zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }

    var body: some View {
        VStack {
            Text("Login Success \(email)")
            Form {
                Section(header: Text("請輸入事件")) {
                    TextField("Activity", text:$val)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Picker(selection: $val1) {
                        ForEach(hours, id: \.self) { hour in
                            Text(hour)
                        }
                    } label: {
                        Text("選擇時間（小時）")
                    }
                    
                    DatePicker("DeadLine", selection: $dd, displayedComponents: .date)
                }
            }
            Button {
                print(dd)
                val2 = WelcomeView.DateConvertString(date: dd)
                print(val2)
                dBHP.AddData(act: val, len: val1, dd: val2)
            } label: {
                Text("Upload")
            }
            
            Button {
                dBHP.DeleteData()
            } label: {
                Text("Delete")
            }
            
            Button {
                dBHP.GetData()
            } label: {
                Text("get")
            }
            
            Button {
                try! FirebaseManager.shared.auth.signOut()
                self.isLogin = false
            } label: {
                Text("Sign Out")
            }
//
//            if let errMsg = dBHP.errMsg {
//                Text(errMsg)
//                    .foregroundColor(Color.red)
//                    .padding(.top, 10)
//            }
            List(dBHP.userData.indices, id: \.self) { idx in
                Text("Activity:\(dBHP.userData[idx].k)\nLength: \(dBHP.userData[idx].v)\nDeadLine: \(dBHP.userData[idx].l)")
            }
        }
    }
}


//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView()
//    }
//}
