//
//  DailyView.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/8.
//

import SwiftUI
struct DailyView: View {
    @ObservedObject var viewModel1 = HomeViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(viewModel1: HomeViewModel())
    }
}
