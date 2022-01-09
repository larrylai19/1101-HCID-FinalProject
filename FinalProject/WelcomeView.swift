import SwiftUI
struct DataDetail{
    var k = ""
    var v = ""
    var l = ""
}


class DBHelper: ObservableObject {
    @Published var userData = [DataDetail]()
    @Published var FreeTimeData = [DataDetail]()
    @Published var errMsg: String? = nil
    @Published var uploadData = [String: Any]()
    @Published var Count = [String: Any]()
    @Published var avaliable = [String: Bool]()
    @Published var freetime = [Bool]()
    @Published var timesection = ["00:00~01:00","01:00~02:00","02:00~03:00","03:00~04:00","04:00~05:00","05:00~06:00","06:00~07:00","07:00~08:00","08:00~09:00","09:00~10:00","10:00~11:00","11:00~12:00","12:00~13:00","13:00~14:00","14:00~15:00","15:00~16:00","16:00~17:00","17:00~18:00" ,"18:00~19:00","19:00~20:00","20:00~21:00","21:00~22:00","22:00~23:00","23:00~00:00"
        ]
    @Published var c:Int = 0 {
        willSet {
            print("old: \(c), new: \(newValue)")
        }
    }
    
    @Published var f:Int = 0 {
        willSet {
            print("old: \(f), new: \(newValue)")
        }
    }
    
    var firstGetData = false
    
    public func priority(){
        self.userData.sort {
            $0.l < $1.l
        }
    }
    
    public func GetFreeTimeData() {
        //        getCount()
        print("GETDATA(C): \(self.f)")
        self.errMsg = nil
        self.FreeTimeData.removeAll()
        self.uploadData.removeAll()
        self.Count.removeAll()
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        for index in 0...self.f {
            FirebaseManager.shared.firestore.collection("users").document(uid).collection("events").document("Free"+String(index)).getDocument { snapshot, err in
                if let err = err {
                    print("Failed: \(err)")
                    self.errMsg = "\(err)"
                    return
                }
                
                
                guard let data = snapshot?.data() else {
                    print("No Freedata found")
                    self.errMsg = "No Freedata found"
                    //self.firstGetData = true
                    return
                }
                
                self.FreeTimeData.append(DataDetail(k: data["Date"] as! String, v: data["Start"] as! String , l:data["End"] as! String))
                //                    print(self.userData)
                //self.firstGetData = true
            }
        }
    }
    
    public func getAvaliable() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        freetime.removeAll()
        FirebaseManager.shared.firestore.collection("users").document(uid).collection("events").document("avaliable").getDocument { [self] snapshot, err in
            if let err = err {
                print("Failed: \(err)")
                self.errMsg = "\(err)"
                return
            }
            
            guard let Free = snapshot?.data() else {
                print("No Freetime found")
                self.errMsg = "No Freetime found"
                //self.firstGetData = true
                for i in 0...23 {
                    self.avaliable[self.timesection[i]] = true
                    self.freetime.append(true)
                }
                FirebaseManager.shared.firestore.collection("users")
                    .document(uid).collection("events").document("avaliable").setData(self.avaliable) { [self] err in
                        if let err = err {
                            print(err)
                            return
                        }
                    }
                return
            }
            
            
            if(self.freetime.count <= 24){
                for i in 0...23 {
                    self.freetime.append(Free[self.timesection[i]] as! Bool )
                    self.avaliable[self.timesection[i]] = Free[self.timesection[i]] as! Bool
                }
            }
        }
    }
    
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
                //self.firstGetData = true
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
    
    public func getFreeCount() {
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).collection("events").document("Freecount").getDocument { snapshot, err in
            if let err = err {
                print("Failed: \(err)")
                self.errMsg = "\(err)"
                return
            }
            
            
            guard let count = snapshot?.data() else {
                print("No Freecount found")
                self.errMsg = "No Freedata found"
                //self.firstGetData = true
                self.Count["count"] = "0"
                FirebaseManager.shared.firestore.collection("users")
                    .document(uid).collection("events").document("Freecount").setData(self.Count) { [self] err in
                        if let err = err {
                            print(err)
                            return
                        }
                    }
                return
            }
            self.f = Int(count["count"] as! String) ?? 0
            print(self.f)
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
                    self.priority()
                    print(self.userData)
                    self.firstGetData = true
                }
        }
        self.firstGetData = true
    }
    
    public func AddData(act: String, len: String, dd:String ) {
        getCount()
        uploadData.removeAll()
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
    
    public func AddFreeData(act: String, len: String, dd:String ) {
        getFreeCount()
        uploadData.removeAll()
        self.errMsg = nil
//        if self.firstGetFreeData == false {
//            self.errMsg = "Get data first!"
//            print("ERR")
//            return
//        }
        
        if act.isEmpty || len.isEmpty {
            self.errMsg = "key or val is empty!"
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        if self.uploadData["Free"+String(self.f)] == nil {
            self.FreeTimeData.append(DataDetail(k: act, v: len , l:dd))
        }
        print("FreeTimeEvent: ",act,len,dd)
        self.uploadData["Date"] = act
        self.uploadData["Start"] = len
        self.uploadData["End"] = dd
        
        let subString = String(dd.prefix(2))
        let subString1 = String(len.prefix(2))
        if(dd == "00:00"){
            self.uploadData["Length"] = String(24 - Int(subString1)!)
        }
        else{
            self.uploadData["Length"] = String(Int(subString)! - Int(subString1)!)
        }
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).collection("events").document("Free"+String(self.f)).setData(self.uploadData) { [self] err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success add data")
            }
        self.f += 1
        self.Count["count"] = String(self.f)
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).collection("events").document("Freecount").setData(self.Count) { [self] err in
                if let err = err {
                    print(err)
                    return
                }
                print("Success add data \"num\": \"\(f)\"")
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
            Spacer()
            Text("Input Activity")
                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                .bold()
                .font(.system(size: 30))
                .padding(.top, 100)
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            Form {
                TextField("Activity", text:$val)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    
                
                Picker(selection: $val1) {
                    ForEach(hours, id: \.self) { hour in
                        Text(hour)
                    }
                } label: {
                    Text("Length")
                        .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
                }
                
                DatePicker("DeadLine", selection: $dd, displayedComponents: .date)
                    .foregroundColor(Color(red: 192/255, green: 192/255, blue: 192/255))
            }
            .background(Color.white)
            .onAppear { // ADD THESE
                UITableView.appearance().backgroundColor = .clear
                //UIScrollView.appearance().isScrollEnabled = false
            }
            .frame(maxHeight: .infinity, alignment: .center)
            .padding(.top, 100)
            
            NavigationLink {
                HomeView()
            } label : {
                Button {
                    print(dd)
                    val2 = WelcomeView.DateConvertString(date: dd)
                    print(val2)
                    dBHP.AddData(act: val, len: val1, dd: val2)
                } label: {
                    Text("Upload")
                        .frame(width: 100, height: 40, alignment: .center)
                        .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.top, 0)
            }
            
            
            //                Button {
            //                    dBHP.DeleteData()
            //                } label: {
            //                    Text("Delete")
            //                        .frame(width: 100, height: 40, alignment: .center)
            //                        .background(Color(red: 82/255, green: 85/255, blue: 123/255))
            //                        .font(.system(size: 18))
            //                        .foregroundColor(.white)
            //                        .cornerRadius(10.0)
            //                        .frame(maxHeight: .infinity, alignment: .center)
            //                }
                            
            //                Button {
            //                    dBHP.GetData()
            //                } label: {
            //                    Text("get")
            //                        .frame(width: 100, height: 40, alignment: .center)
            //                        .background(Color(red: 82/255, green: 85/255, blue: 123/255))
            //                        .font(.system(size: 18))
            //                        .foregroundColor(.white)
            //                        .cornerRadius(10.0)
            //                        .frame(maxHeight: .infinity, alignment: .center)
            //                }
                            
            //                Button {
            //                    try! FirebaseManager.shared.auth.signOut()
            //                    self.isLogin = false
            //                } label: {
            //                    Text("Sign Out")
            //                        .frame(width: 100, height: 40, alignment: .center)
            //                        .background(Color(red: 82/255, green: 85/255, blue: 123/255))
            //                        .font(.system(size: 18))
            //                        .foregroundColor(.white)
            //                        .cornerRadius(10.0)
            //                        .frame(maxHeight: .infinity, alignment: .center)
            //                }
//
//            if let errMsg = dBHP.errMsg {
//                Text(errMsg)
//                    .foregroundColor(Color.red)
//                    .padding(.top, 10)
//            }
//            List(dBHP.userData.indices, id: \.self) { idx in
//                Text("Activity:\(dBHP.userData[idx].k)\nLength: \(dBHP.userData[idx].v)\nDeadLine: \(dBHP.userData[idx].l)")
//            }
        }
    }
}


//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView(dBHP: DBHelper())
//    }
//}
