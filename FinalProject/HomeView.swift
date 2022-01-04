//
//  HomeView.swift
//  CalendarDemo
//
//  Created by Dmitrijs Beloborodovs on 31/05/2021.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var dBHP = DBHelper()
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
                Spacer()
                HStack{
                    Button(action: {
                        dBHP.getCount()
                        dBHP.GetData()
                    }, label: {
                        Text("Show")
                    })
                    
                    NavigationLink {
                        WelcomeView()
                    } label: {
                        Text("Add")
                    }
                }
                Text(viewModel.selectedDate)
                    .padding()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}

#endif
