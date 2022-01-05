//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/3.
//

import Foundation
import FSCalendar
import SwiftUI

class HomeViewModel: NSObject, ObservableObject {
    
    @Published var calendar = FSCalendar()
    @Published var isCalendarExpanded: Bool = true
    @Published var calendarHeight: CGFloat = 300.0
    @Published var selectedDate: String = ""
    @ObservedObject var dBHP = DBHelper()

    override init() {
        super.init()
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = isCalendarExpanded ? .month : .week
        calendar.firstWeekday = 2
    }
}

extension HomeViewModel: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        dateSelected(date)
    }
    
    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {
        calendarHeight = bounds.height
    }
    
    
}

extension HomeViewModel: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar,
                  numberOfEventsFor date: Date) -> Int {
        numberOfEvent(for: date)
    }
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        let dateString = self.dateFormatter.string(from: date)
//
//        if self.datesWithEvent.contains(dateString) {
//            return 1
//        }
//        if self.datesWithMultipleEvents.contains(dateString) {
//            return 3
//        }
//        return 0
//    }
//
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        let key = self.dateFormatter.string(from: date)
//        if self.datesWithMultipleEvents.contains(key) {
//            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
//        }
//        return nil
//    }
}

private extension HomeViewModel {
    func numberOfEvent(for date: Date) -> Int {
//        let dateString = self.dateFormatter.string(from: date)
//
//        if self.datesWithEvent.contains(dateString) {
//            return 1
//        }
//        if self.datesWithMultipleEvents.contains(dateString) {
//            return 3
//        }
        //do sth
        return 0
    }
    
    func dateSelected(_ date: Date) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.selectedDate = date.description
        }
    }
}
