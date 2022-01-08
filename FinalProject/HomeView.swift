//
//  HomeView.swift
//  CalendarDemo
//
//  Created by Dmitrijs Beloborodovs on 31/05/2021.
//

import SwiftUI

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
    }
    
    var body: some View {
        NavigationView {
            VStack {
                CalendarView(calendar: viewModel.calendar,
                             isCalendarExpanded: $viewModel.isCalendarExpanded)
                    .frame(maxWidth: .infinity)
                    .frame(height: viewModel.calendarHeight)
                
                Spacer()
                Text("To-do List")
                if(viewModel.all)
                {
                    List(dBHP.userData.indices, id: \.self) { idx in
                        Text("Activity:\(dBHP.userData[idx].k)\nLength: \(dBHP.userData[idx].v)\nDeadLine: \(dBHP.userData[idx].l)")
                    }
                }
                else {
                    List(viewModel.selectedEvent.indices, id: \.self) { idx in
                        Text("Activity:\(viewModel.selectedEvent[idx])")
                    }
                }
                Spacer()
                HStack{
                    Button(action: {
//                        dBHP.getCount()
                        print("homeview: \(dBHP.c)")
                        viewModel.all = true
                        dBHP.GetData()
                    }, label: {
                        Text("Show All")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        //print(dBHP.userData.count)
                        viewModel.de.removeAll()
                        viewModel.datesArray.removeAll()
                        for i in 0..<dBHP.userData.count{
                            self.viewModel.updateArray(day: dBHP.userData[i].l, activity: dBHP.userData[i].k)
                        }
                        viewModel.calendar.reloadData()
                    }, label: {
                        Text("update")
                    })
                    
                    Spacer()
                    
                    NavigationLink {
                        WelcomeView(dBHP: self.dBHP)
                    } label: {
                        Text("Add")
                    }
                    
                    Spacer()
                    
                    NavigationLink {
                        DailyScheduleView(dBHP: self.dBHP)
                    } label: {
                        Text("Daily")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            viewModel.isCalendarExpanded.toggle()
                        }
                    }, label: {
                        Image(systemName: "list.bullet.below.rectangle")
                    })
                }
            }
            .navigationTitle("我的Calendar")
            .navigationBarTitleDisplayMode(.inline)

        }

        
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
