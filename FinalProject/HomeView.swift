//
//  HomeView.swift
//  CalendarDemo
//
//  Created by Dmitrijs Beloborodovs on 31/05/2021.
//

import SwiftUI

func stringConvertDate(string:String, dateFormat:String="yyyy-MM-dd") -> Date{
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: string)
    return date!
}

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @ObservedObject var dBHP = DBHelper()
    
    init() {
        self.dBHP.getCount()
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
                List(dBHP.userData.indices, id: \.self) { idx in
                    Text("Activity:\(dBHP.userData[idx].k)\nLength: \(dBHP.userData[idx].v)\nDeadLine: \(dBHP.userData[idx].l)")
                }
                Text(viewModel.selectedDate)
                    .padding()
                Spacer()
                HStack{
                    Button(action: {
//                        dBHP.getCount()
                        print("homeview: \(dBHP.c)")
                        dBHP.GetData()
                    }, label: {
                        Text("Show All")
                    })
                    
                    NavigationLink {
                        WelcomeView(dBHP: self.dBHP)
                    } label: {
                        Text("Add")
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
