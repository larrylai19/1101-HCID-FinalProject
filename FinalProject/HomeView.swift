//
//  HomeView.swift
//  CalendarDemo
//
//  Created by Dmitrijs Beloborodovs on 31/05/2021.
//

import SwiftUI

let color1 = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)


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
    
    init() {
        serialQueue1.sync {
            self.dBHP.getCount()
            print("Count",dBHP.c)
        }
        
        serialQueue1.sync {
            self.dBHP.GetData()
            print("Count",dBHP.c)
        }
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
            
            if(viewModel.selected)
            {
                WelcomeView(dBHP: self.dBHP)
            }
            else
            {
                CalendarView(calendar: viewModel.calendar                         )//isCalendarExpanded: $viewModel.isCalendarExpanded
                    .frame(maxWidth: .infinity)
                    .frame(height: viewModel.calendarHeight)
            }
            
            Divider()
                .background(Color(red: 242/255, green: 242/255, blue: 246/255))
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
                List(dBHP.userData.indices, id: \.self) { idx in
                    VStack(alignment: .leading) {
                        Text("\(dBHP.userData[idx].k)")
                            .foregroundColor(Color(red: 183/255, green: 101/255, blue: 122/255))
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                        Text("\(dBHP.userData[idx].v)  \(dBHP.userData[idx].l)")
                            .foregroundColor(Color(red: 230/255, green: 108/255, blue: 114/255))
                    }
                    
                }
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
