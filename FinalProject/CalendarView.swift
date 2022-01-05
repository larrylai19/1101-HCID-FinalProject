import SwiftUI
import FSCalendar

func stringConvertDate1(string:String, dateFormat:String="yyyy-MM-dd") -> Date{
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: string)
    return date!
}

struct CalendarView: UIViewRepresentable{
    var calendar: FSCalendar
    @Binding var isCalendarExpanded: Bool
    @ObservedObject var dBHP = DBHelper()
    func makeUIView(context: Context) -> FSCalendar {
        calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        let scope:FSCalendarScope = isCalendarExpanded ? .month : .week
        uiView.setScope(scope,animated:false)
        
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(dBHP.userData[0].k)
//    }
//    class Coordinator: NSObject, UITextViewDelegate {
//        var text: Binding<String>
//        init(_ text: Binding<String>) {
//            self.text = text
//        }
//        func textViewDidChange(_ textView: UITextView) {
//            self.text.wrappedValue = textView.text
//        }
//    }
}
