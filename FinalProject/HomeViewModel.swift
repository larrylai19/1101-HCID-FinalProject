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
    @Published var selected:Bool = false
    @Published var calendarHeight: CGFloat = 300.0
    @Published var selectedDate: String = ""
    @Published var datesArray = [String]()
    @Published var de = [dayEvent]()
    @Published var selectedEvent = [String]()
    func updateArray(day:String,activity:String) {
        datesArray.append(day)
        self.de.append(dayEvent(day: day, act: activity))
    }
    
    
    override init() {
        super.init()

        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = isCalendarExpanded ? .month : .week
        calendar.firstWeekday = 2
        //calendar.scrollDirection = .horizontal
//        de.removeAll()
//        datesArray.removeAll()
//        for i in 0..<self.dBHP.userData.count{
//            self.viewModel.updateArray(day: dBHP.userData[i].l, activity: dBHP.userData[i].k)
//        }
        //header
        calendar.appearance.headerTitleColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        calendar.calendarHeaderView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //week
        calendar.appearance.weekdayTextColor = UIColor(red: 183/255, green: 101/255, blue: 122/255, alpha: 1)
        calendar.calendarWeekdayView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        //cell
        calendar.collectionView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
//        calendar.appearance.titleOffset = CGPoint.init(x: 50, y: 0.0)
//        calendar.appearance.eventOffset = CGPoint.init(x: 50, y: 0.0)
        
        //calendar.appearance.separators = .interRows
        
        
        calendar.appearance.todaySelectionColor = UIColor(red: 230/255, green: 108/255, blue: 114/255, alpha: 1)
        //calendar.appearance.eventDefaultColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        calendar.appearance.todayColor = UIColor(red: 82/255, green: 85/255, blue: 123/255, alpha: 1)
        calendar.appearance.selectionColor = UIColor(red: 230/255, green: 108/255, blue: 114/255, alpha: 1)
        //calendar.appearance.eventSelectionColor = UIColor(red: 183/255, green: 101/255, blue: 122/255, alpha: 1)
        
        //outside frame
        //calendar.layer.borderWidth = 3
        
        //collection frame
        //calendar.collectionView.layer.borderWidth = 3
        
        //calendar.collectionView.lineWidth = 3
        //calendar.collectionView.cellForItem(at: IndexPath)
        
    }
}

extension HomeViewModel: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar,
                  didSelect date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        
        selected = true
        dateSelected(date)
        
        
        //updateEvent()
    }
    
    func calendar(_ calendar: FSCalendar,
                  boundingRectWillChange bounds: CGRect,
                  animated: Bool) {
        calendarHeight = bounds.height
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("action")
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        
        //display events as dots
        cell.eventIndicator.isHidden = false
        cell.eventIndicator.color = generateRandomColor()
        print("datesArray",datesArray)
        print("dateString",dateString)
        if self.datesArray.contains(dateString){
            cell.eventIndicator.numberOfEvents = 1
        }
    }
    
}

extension HomeViewModel: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter3.string(from: date)
        
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
