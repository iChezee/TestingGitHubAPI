import Foundation
import Combine

enum SelectedPeriod: Int, CaseIterable {
    case day = 0
    case week
    case year
    
    var title: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .year:
            return "Year"
        }
    }
}

class RepositoriesSceneViewModel: ObservableObject {
    @Published var searchText = ""
    
    func periodChanged(for period: SelectedPeriod) {
        
    }
    
    func onSearchTextchanged(_ text: String) {
        
    }
    
    func onSearchTextSelected(_ text: String) {
        
    }
}
