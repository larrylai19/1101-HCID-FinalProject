import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable{
    var calendar: FSCalendar
    @Binding var isCalendarExpanded: Bool
    
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
