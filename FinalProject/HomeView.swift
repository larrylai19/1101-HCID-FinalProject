//
//  HomeView.swift
//  CalendarDemo
//
//  Created by Dmitrijs Beloborodovs on 31/05/2021.
//

import SwiftUI

let color1 = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)

struct Activity: Identifiable{
    var id = UUID()
    var name:String
    var length:String
}

var activity = [
    Activity(name: "Cafe Deadend", length: "cafedeadend"),
    Activity(name: "Homei", length: "homei"),
    Activity(name: "Teakha", length: "teakha"),
    Activity(name: "Cafe Loisl", length: "cafeloisl")
]


var ActivityNames = ["hw1", "hw2", "hw3", "hw4"]

var ActivityLength = ["1", "2", "3", "4"]

struct BasicImageRow: View {
    var thisActivity:DataDetail
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(thisActivity.k)
                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Text(thisActivity.l)
                    .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
            }
        }
    }
}

struct ScheduleDetailView:View{
    @Environment(\.presentationMode) var presentationMode
    var thisActivity:DataDetail
    var dBHP: DBHelper
    var body: some View{
        ScrollView{
            VStack{
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color(red: 82/255, green: 85/255, blue: 123/255))
                        .frame(width: 400, height: 300)
                        .cornerRadius(15.0)
                        .padding(.top, 0)
                    Text(thisActivity.k)
                        //.font(.system(.title, design:.rounded))
                        .font(.system(size: 40))
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                        .font(.system(.title, design:.rounded))
                }
                HStack {
                    Text("Length: ")
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                    Text(thisActivity.v)
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                }
                HStack {
                    Text("Deadline: ")
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                    Text(thisActivity.l)
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
            Spacer()
            Button {
                dBHP.deleteSingle(pos: thisActivity.eventCnt)
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Delete")
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
                    .padding(.top, 70)
            }
            .padding(.bottom, 10)
        }
    }
}

struct ActivityDetailView:View{
    @Environment(\.presentationMode) var presentationMode
    var thisActivity:DataDetail
    var dBHP: DBHelper
    var body: some View{
        ScrollView{
            VStack{
                Spacer()
                ZStack {
                    Rectangle()
                        .fill(Color(red: 82/255, green: 85/255, blue: 123/255))
                        .frame(width: 400, height: 300)
                        .cornerRadius(15.0)
                        .padding(.top, 0)
                    Text(thisActivity.k)
                        //.font(.system(.title, design:.rounded))
                        .font(.system(size: 40))
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                        .font(.system(.title, design:.rounded))
                }
                HStack {
                    Text("Length: ")
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                    Text(thisActivity.v)
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                }
                HStack {
                    Text("Deadline: ")
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                    Text(thisActivity.l)
                        .font(.system(.title, design:.rounded))
                        .fontWeight(.black)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .padding()
            Spacer()
            Button {
                dBHP.deleteSingle(pos: thisActivity.eventCnt)
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Delete")
                    .frame(width: 100, height: 40, alignment: .center)
                    .background(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .cornerRadius(10.0)
                    .padding(.top, 70)
            }
            .padding(.bottom, 10)
        }
    }
}

struct HomeView: View {
    @ObservedObject var dBHP = DBHelper()
//    {
//        didSet {
//            print("DeBug:\(oldValue)\nd\(dBHP)")
//        }
//    }
    @ObservedObject var viewModel = HomeViewModel()
    let serialQueue1 = DispatchQueue(label: "com.waynestalk.serial")
    var date = Date()
    
    @State var selectedDetail: DataDetail?
    
    @State var showDetailView = false
    
    init() {
        serialQueue1.sync {
            self.dBHP.getCount()
            print("Count",dBHP.c)
        }
        
        self.dBHP.getAllData()
        serialQueue1.sync {
            self.viewModel.all = true
        }
        self.dBHP.getAvaliable()
        //UITableView.appearance().separatorStyle = .none
        //UITableViewCell.appearance().backgroundColor = .white
        //UITableView.appearance().backgroundColor = .white
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text("My Calendar")
                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                HStack {
                    Spacer()
                    NavigationLink {
                        AddFreeTimeView(dBHP: self.dBHP)
                    } label: {
                        Text("+       ")
                            .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                    }
                }
            }
            .padding(.top, 0)
            
//            if(viewModel.selected)
//            {
//                //ScheduleDetailView(thisActivity: detail, dBHP: self.dBHP)
//            }
//            else
//            {
//                CalendarView(calendar: viewModel.calendar                         )//isCalendarExpanded: $viewModel.isCalendarExpanded
//                    .frame(maxWidth: .infinity)
//                    .frame(height: viewModel.calendarHeight)
//            }
            CalendarView(calendar: viewModel.calendar                         )//isCalendarExpanded: $viewModel.isCalendarExpanded
                .frame(maxWidth: .infinity)
                .frame(height: viewModel.calendarHeight)
                .background(Color(red: 242/255, green: 242/255, blue: 246/255))
            Divider()
            ZStack {
                Text("To-do List")
                    .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                HStack {
                    Button(action: {
    //                        dBHP.getCount()
                        print("homeview: \(dBHP.c)")
                        viewModel.all = true
                        dBHP.GetData()
                    }, label: {
                        VStack{
                            Image(systemName: "list.bullet")
                                .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
                        }
                    })
                    .padding()
                    
                    Spacer()
                    NavigationLink {
                        WelcomeView(dBHP: self.dBHP)
                    } label: {
                        Text("+       ")
                            .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
                            .fontWeight(.bold)
                            .font(.system(size: 25))
                    }
                }
            }
            
            if(viewModel.all)
            {
                List(dBHP.userData) { detail in
                    BasicImageRow(thisActivity: detail)
                        .onTapGesture {
                            self.showDetailView = true
                            self.selectedDetail = detail
                        }
                }
                .sheet(item: self.$selectedDetail, content: { detail in
                    ActivityDetailView(thisActivity: detail, dBHP: self.dBHP)
                })
//                List(dBHP.userData) { idx in
////                    HStack {
////                        VStack(alignment: .leading) {
////                            Text("\(dBHP.userData[idx].k)")
////                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
////                                .fontWeight(.bold)
////                                .font(.system(size: 20))
////                            Text("\(dBHP.userData[idx].v)  \(dBHP.userData[idx].l)")
////                                .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
////                        }
////                        Spacer()
////                        Button {
////                            dBHP.deleteSingle(pos: dBHP.userData[idx].eventCnt)
////                        } label: {
////                            Text("-")
////                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
////                                .fontWeight(.bold)
////                                .font(.system(size: 25))
////                        }
////                    }
//                    var oneActivity = Activity(name:dBHP.userData[idx].k, length:dBHP.userData[idx].l)
//                    BasicImageRow(thisActivity: oneActivity)
//                        .onTapGesture {
//                            self.showDetailView = true
//                            self.selectedRestaurant = restaurantItem
//                        }
//                }
//                .sheet(item: self.$selectedDetail, content: { idx in
//                    var oneActivity = Activity(name:dBHP.userData[idx].k, length:dBHP.userData[idx].l)
//                    ActivityDetailView(thisActivity: oneActivity)
//                })
            }
            else {
                List(viewModel.selectedEvent.indices, id: \.self) { idx in
                    Text("Activity:\(viewModel.selectedEvent[idx])")
                }
            }
            //Spacer()
//            HStack{
//                Button(action: {
////                        dBHP.getCount()
//                    print("homeview: \(dBHP.c)")
//                    viewModel.all = true
//                    dBHP.GetData()
//                }, label: {
//                    VStack{
//                        Image(systemName: "book")
//                            .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                        Text("Show All")
//                            .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                            .fontWeight(.bold)
//                    }
//                })
                
//                    Spacer()
                
//                Button(action: {
//                    //print(dBHP.userData.count)
//                    viewModel.de.removeAll()
//                    viewModel.datesArray.removeAll()
//                    for i in 0..<dBHP.userData.count{
//                        self.viewModel.updateArray(day: dBHP.userData[i].l, activity: dBHP.userData[i].k)
//                    }
//                    viewModel.calendar.reloadData()
//                }, label: {
//                    Text("update")
//                        .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                        .fontWeight(.bold)
//                })
                
//                    Spacer()
                
//                NavigationLink {
//                    WelcomeView(dBHP: self.dBHP)
//                } label: {
//                    Text("Add")
//                        .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                        .fontWeight(.bold)
//                }
                
//                    Spacer()
                
//                    NavigationLink {
//                        DailyScheduleView(dBHP: self.dBHP)
//                    } label: {
//                        Text("Daily")
//                    }
//            }
        }
        .padding(.top, 0)
        //.padding(.top, 0)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(action: {
//                    withAnimation {
//                        viewModel.isCalendarExpanded.toggle()
//                    }
//                }, label: {
//                    Image(systemName: "list.bullet.below.rectangle")
//                })
//            }
//        }
//        .navigationBarTitle(Text("My Calendar")
//                                .foregroundColor(Color(red: 82/255, green: 85/255, blue: 123/255))
//                                .fontWeight(.bold)
//                                .font(.system(size: 25)), displayMode: .inline)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG

private final class MockedViewModel: HomeViewModel {
    
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(viewModel: HomeViewModel())
//    }
//}

#endif
