import Foundation
import Combine

class RepositoriesSceneViewModel: ObservableObject {
    @Published var repositories = [Repository]()
    
    init() {
        
    }
    
    func favouriteTapped(_ repo: Repository) {
        
    }
    
    func periodChanged(for period: SelectedPeriod) {
        
    }
    
    func onSearchTextChanged(_ text: String) {
        
    }
    
    func onSearchTextSelected(_ text: String) {
        
    }
}

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
