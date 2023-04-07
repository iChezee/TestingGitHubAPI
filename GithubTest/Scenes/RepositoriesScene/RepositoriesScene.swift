import SwiftUI

struct RepositoriesScene: View {
    
    @ObservedObject var viewModel = RepositoriesSceneViewModel()
    @State var selectedPeriod = 0
    
    var body: some View {
        VStack(spacing: Sizes.medium) {
            GHImage.ghLogo.view
                .resizable()
                .frame(width: Sizes.logoSize, height: Sizes.logoSize)
                .background(GHColor.background.view)
            periodPicker
            SearchBar(onSearchChanged: ( viewModel.onSearchTextchanged ),
                      onSearchTapped: ( viewModel.onSearchTextSelected ),
                      onEraseTapped: { viewModel.onSearchTextSelected("") })
            mainList
        }
        .padding(.top, Sizes.medium)
        .padding(.horizontal, Sizes.medium)
        .background(GHColor.background.view.ignoresSafeArea())
    }
    
    var periodPicker: some View {
        Picker("Select period", selection: $selectedPeriod) {
            ForEach(SelectedPeriod.allCases, id: \.rawValue) {
                Text($0.title)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: selectedPeriod) { newValue in
            if let period = SelectedPeriod(rawValue: newValue) {
                viewModel.periodChanged(for: period)
            }
        }
    }
    
    var mainList: some View {
        List { }
    }
}

extension Sizes {
    static let logoSize: CGFloat = 64
}
