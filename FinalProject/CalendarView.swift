import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    
    let interval: DateInterval
    let showHeaders: Bool
    let content: (Date) -> DateView
    
    init(
        interval: DateInterval,
        showHeaders: Bool = true,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.interval = interval
        self.showHeaders = showHeaders
        self.content = content
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(months, id: \.self) { month in
                Section(header: header(for: month)) {
                    ForEach(days(for: month), id: \.self) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(date).id(date)
                        } else {
                            content(date).hidden()
                        }
                    }
                }
            }
        }
    }
    
    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    private func header(for month: Date) -> some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        
        return Group {
            if showHeaders {
                Text(formatter.string(from: month))
                    .font(.title)
                    .padding()
            }
        }
    }
    
    private func days(for month: Date) -> [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month),
            let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(
            inside: DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end),
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
}

//struct RootView: View {
//    @Environment(\.calendar) var calendar
//
//    private var year: DateInterval {
//        calendar.dateInterval(of: .year, for: Date())!
//    }
//
//    var body: some View {
//        CalendarView(interval: year) { date in
//            Text(String(self.calendar.component(.day, from: date)))
//                .frame(width: 40, height: 40, alignment: .center)
//                .background(Color.blue)
//                .clipShape(Circle())
//                .padding(.vertical, 4)
//        }
//    }
//}

struct RootView: View {
    @Environment(\.calendar) var calendar
    @State var components = DateComponents()
    @State var desiredDate = Date()
    @State var selectedDateList : [Date] = [].self
    private var monthly: DateInterval {
        var monthComponent = DateComponents()
        monthComponent.month = 3
        let endDate = self.calendar.date(byAdding: monthComponent, to: self.desiredDate) ?? Date()
        return DateInterval(start: Date(), end: endDate)
    }
    var body: some View {
        CalendarView(interval: monthly) { date in
            
            //Previous Dates from current date
            if(self.getPrevioudDateViewFlag(date: date as NSDate)){
                Text("30").hidden()
                    .padding(8)
                    .background( Color.gray)
                    .clipShape(Circle())
                    .padding(.vertical, 4)
                    .overlay(
                        Text(self.getCurrentDate(date: date as NSDate))
                    )
            }
            //Once user will select any date
            else if(self.getSelectedDate(date: date as NSDate)){
                Text("30").hidden()
                    .padding(8)
                    .background(Color.orange)
                    .clipShape(Circle())
                    .padding(.vertical, 4)
                    .overlay(
                        Text(self.getCurrentDate(date: date as NSDate))
                    )
                    .onTapGesture{
                        self.updateSelectedDate(date: date as NSDate)
                    }
            }
            //Current Date
            else if(self.getCurrentDateViewFalg(date: date as NSDate)){
                Text("30").hidden()
                    .padding(8)
                    .background(Color.red)
                    .clipShape(Circle())
                    .padding(.vertical, 4)
                    .overlay(
                        Text(self.getCurrentDate(date: date as NSDate))
                    )
                    .onTapGesture{
                        self.updateSelectedDate(date: date as NSDate)
                        self.components.month = self.calendar.component(.month, from: date)
                        self.components.day = self.calendar.component(.day, from: date)
                        self.components.year = self.calendar.component(.year, from: date)
                    }
            }
            //Other Dates
            else{
                Text("30").hidden()
                    .padding(8)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .padding(.vertical, 4)
                    .overlay(
                        Text(self.getCurrentDate(date: date as NSDate))
                    )
                    .onTapGesture{
                        self.updateSelectedDate(date: date as NSDate)
                        self.components.month = self.calendar.component(.month, from: date)
                        self.components.day = self.calendar.component(.day, from: date)
                        self.components.year = self.calendar.component(.year, from: date)
                    }
            }
        }
    }
    func getCurrentDate(date : NSDate) -> String{
        return String(self.calendar.component(.day, from: date as Date))
    }
    func getCurrentDateViewFalg(date : NSDate) -> Bool{
        if(self.calendar.component(.day, from: date as Date) == self.calendar.component(.day, from: self.desiredDate)        &&  self.calendar.component(.month, from: date as Date) == self.calendar.component(.month, from: self.desiredDate)){
            return true
        }
        return false
    }
    func getPrevioudDateViewFlag(date : NSDate) -> Bool{
        if(self.calendar.component(.day, from: date as Date) < self.calendar.component(.day, from: self.desiredDate) &&  self.calendar.component(.month, from: date as Date) == self.calendar.component(.month, from: self.desiredDate)){
            return true
        }
        return false
    }
    func getSelectedDate(date : NSDate) -> Bool{
        for item in selectedDateList{
            if item == date as Date {
                return true
            }
        }
        return false
    }
    func updateSelectedDate(date : NSDate){
        if(!self.selectedDateList.contains(date as Date)){
            self.selectedDateList.append(date as Date)
        }
        else{
            if(self.selectedDateList.contains(date as Date)){
                let index =  self.selectedDateList.firstIndex(of: date as Date)
                self.selectedDateList.remove(at: index!)
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
