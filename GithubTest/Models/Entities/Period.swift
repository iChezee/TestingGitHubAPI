import Foundation

enum Period: Int, Identifiable, CaseIterable {
    case day = 0
    case week
    case month
    
    var id: Period { self }
    
    var title: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        switch self {
        case .day:
            return dateFormatter.string(from: Date().addOrSubtractDay(day: -1))
        case .week:
            return dateFormatter.string(from: Date().addOrSubtractDay(day: -7))
        case .month:
            return dateFormatter.string(from: Date().addOrSubtractMonth(month: -1))
        }
    }
}
