import Foundation
import Combine
import SwiftUI

class RepositoriesSceneViewModel: ObservableObject {
    @Published var selectedPeriod: Period {
        didSet {
            currentView = views[selectedPeriod.rawValue]
        }
    }
    @Published var currentView: RepositoriesList
    
    private var views: [RepositoriesList] = []
    
    init() {
        self.selectedPeriod = Period.day
        for period in Period.allCases {
            views.append(period.view)
        }
        self.currentView = views.first!
    }
}
