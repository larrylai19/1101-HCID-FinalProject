//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Larry - 1024 on 2022/1/3.
//

import Foundation
import FSCalendar
import SwiftUI

struct dayEvent{
    var day:String
    var act:String
}

func generateRandomColor() -> UIColor {
    let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
    let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
    let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
    
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
}

class HomeViewModel: NSObject, ObservableObject {
    
    @Published var calendar = FSCalendar()
    @Published var isCalendarExpanded: Bool = true
    @Published var all: Bool = false
    @Published var calendarHeight: CGFloat = 300.0
    @Published var selectedDate: String = ""
    @Published var datesArray = [""]
    @Published var de = [dayEvent]()
    @Published var selectedEvent = [""]
    
    func updateArray(day:String,activity:String) {
        if(datesArray[0] == ""){
            datesArray[0] = day
        }
        else{
            datesArray.append(day)
        }
        self.de.append(dayEvent(day: day, act: activity))
    }
    
    
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
        //updateEvent()
    }
    
    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {
        calendarHeight = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        
        //display events as dots
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = generateRandomColor()
        
        if self.datesArray.contains(dateString){
            cell.eventIndicator.numberOfEvents = 1
        }
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
//        let dateFormatter3 = DateFormatter()
//        dateFormatter3.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter3.string(from: date)
//        if self.datesArray.contains(dateString) {
//            return [UIColor.blue]
//        }
//        return [UIColor.white]
//    }
//
}

extension HomeViewModel: FSCalendarDataSource {
//    func calendar(_ calendar: FSCalendar,
//                  numberOfEventsFor date: Date) -> Int {
//        numberOfEvent(for: date)
//    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        
        print("Dates array at numberOfEvents: ", datesArray)
        print("EventArray",de)
        print("DateString: ", dateString)
        
        //render dots if there is an event on that day
        if self.datesArray.contains(dateString){
            return 1
        }else{
            return 0
        }
        
    }

}

private extension HomeViewModel {
    
    func dateSelected(_ date: Date) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let dateFormatter3 = DateFormatter()
            dateFormatter3.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter3.string(from: date)
            self.selectedDate = dateString
            self.selectedEvent.removeAll()
            
            for i in 0..<self.de.count{
                if(self.de[i].day == dateString && !self.selectedEvent.contains(self.de[i].act))
                {
                    self.selectedEvent.append(self.de[i].act)
                }
            }
            self.all = false
        }
    }
}
