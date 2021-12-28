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
    @Published var c:Int = 0
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
        }
    }
    
    public func GetData() {
        self.errMsg = nil
        self.userData.removeAll()
        self.uploadData.removeAll()
        self.Count.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        getCount()
        print(self.c)
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
                    print(data)
//                    for e in data {
//                        self.userData.append(DataDetail(k: e.key, v: "\(e.value)"))
//                        self.uploadData[e.key] = e.value as! String
//                    }
                    self.userData.append(DataDetail(k: data["Activity"] as! String, v: data["Lengh"] as! String , l:data["DeadLine"] as! String))
                    
                    self.firstGetData = true
                    print(self.userData)
                }
        }
    }
    
    public func AddData(act: String, len: String, dd:String ) {
        getCount()
        self.errMsg = nil
        if self.firstGetData == false {
            self.errMsg = "Get data first!"
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

    @ObservedObject var dBHP = DBHelper()
    @State var key = "Activity"
    @State var val = ""
    @State var key1 = "Length"
    @State var val1 = ""
    @State var key2 = "DeadLine"
    @State var val2 = ""
    @State var dd = Date()
    
    static func DateConvertString(date:Date,dateFormat:String="yyyy-MM-dd") ->String{
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "Zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    init() {
        if FirebaseManager.shared.auth.currentUser != nil {
            dBHP.getCount()
            dBHP.GetData()
        }
    }

    var body: some View {
        VStack {
            Text("Login Success \(uid)\n\(email)")
                .navigationBarHidden(true)

//            Group {
//                TextField("key", text: $key)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//                TextField("val", text: $val)
//                    .disableAutocorrection(true)
//                    .autocapitalization(.none)
//            }
//            .padding(.horizontal, 10)

            Form {
                Section(header: Text("請輸入事件")) {
                    TextField("Activity", text:$val)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Length", text:$val1)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    DatePicker("DeadLine", selection: $dd, displayedComponents: .date)
//                    TextField("DeadLine", text:$val2)
//                        .disableAutocorrection(true)
//                        .autocapitalization(.none)
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
            }

//            Button {
//                dBHP.AddData(key: self.key, val: self.val)
//                dBHP.AddData(key: self.key1, val: self.val1)
//                dBHP.AddData(key: self.key2, val: self.val2)
//            } label: {
//                Text("Upload")
//            }
//
//            Button {
//                dBHP.GetData()
//            } label: {
//                Text("get")
//            }
//
//            Button {
//                try! FirebaseManager.shared.auth.signOut()
//                self.isLogin = false
//            } label: {
//                Text("Sign Out")
//            }

            if let errMsg = dBHP.errMsg {
                Text(errMsg)
                    .foregroundColor(Color.red)
                    .padding(.top, 10)
            }

            List(dBHP.userData.indices, id: \.self) { idx in
                Text("Activity:\(dBHP.userData[idx].k)\nLength: \(dBHP.userData[idx].v)\nDeadLine: \(dBHP.userData[idx].l)")
            }
        }
    }
}


struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
