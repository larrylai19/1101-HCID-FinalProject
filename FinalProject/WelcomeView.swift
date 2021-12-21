//
//  WelcomeView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2021/12/12.
//

import SwiftUI

struct DataDetail {
    var k = ""
    var v = ""
}

class DBHelper: ObservableObject {
    
    @Published var userData = [DataDetail]()
    @Published var errMsg: String? = nil
    @Published var uploadData = [String: Any]()
    
    var firstGetData = false
    
    public func GetData() {
        self.errMsg = nil
        self.userData.removeAll()
        self.uploadData.removeAll()
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, err in
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
            
            for e in data {
                self.userData.append(DataDetail(k: e.key, v: "\(e.value)"))
                self.uploadData[e.key] = e.value as! String
            }
            
            self.firstGetData = true
            print(self.userData)
        }
    }
    
    public func AddData(key: String, val: String) {
        self.errMsg = nil
        
        if self.firstGetData == false {
            self.errMsg = "Get data first!"
            return
        }
        
        if key.isEmpty || val.isEmpty {
            self.errMsg = "key or val is empty!"
            return
        }
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        if self.uploadData[key] == nil {
            self.userData.append(DataDetail(k: key, v: val))
        } else {
            for i in 0..<self.userData.count {
                if self.userData[i].k == key {
                    self.userData[i].v = val
                    break
                }
            }
        }
        
        self.uploadData[key] = val
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(self.uploadData) { err in
                if let err = err {
                    print(err)
                    return
                }
                
                print("Success add data \"\(key)\": \"\(val)\"")
            }
    }
}

struct WelcomeView: View {
    
    @AppStorage("isLogin") var isLogin = false
    var uid = FirebaseManager.shared.auth.currentUser != nil ? FirebaseManager.shared.auth.currentUser?.uid as! String : ""
    var email = FirebaseManager.shared.auth.currentUser?.email as! String
    @ObservedObject var dBHP = DBHelper()
    
    @State var key = ""
    @State var val = ""
    
    init() {
        if FirebaseManager.shared.auth.currentUser != nil {
            dBHP.GetData()
        }
    }
    
    var body: some View {
        VStack {
            Text("Login Success \(uid)\n\(email)")
                .navigationBarHidden(true)
            
            Group {
                TextField("key", text: $key)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                TextField("val", text: $val)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            .padding(.horizontal, 10)
            
            Button {
                dBHP.AddData(key: self.key, val: self.val)
            } label: {
                Text("Upload")
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
            
            if let errMsg = dBHP.errMsg {
                Text(errMsg)
                    .foregroundColor(Color.red)
                    .padding(.top, 10)
            }
            
            List(dBHP.userData.indices, id: \.self) { idx in
                Text("\(dBHP.userData[idx].k): \(dBHP.userData[idx].v)")
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
