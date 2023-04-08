import SwiftUI

struct RepositoriesScene: View {
    @ObservedObject var viewModel = RepositoriesSceneViewModel()
    
    var body: some View {
        VStack(spacing: Sizes.medium) {
            GHImage.ghLogo.view
                .resizable()
                .frame(width: Sizes.logoSize, height: Sizes.logoSize)
                .background(GHColor.background.view)
            periodPicker
            viewModel.currentView
        }
        .padding(.top, Sizes.medium)
        .padding(.horizontal, Sizes.medium)
        .background(GHColor.background.view.ignoresSafeArea())
    }
    
    var periodPicker: some View {
        Picker("", selection: $viewModel.selectedPeriod) {
            ForEach(Period.allCases, id: \.self) {
                Text($0.title)
            }
        }
        .pickerStyle(.segmented)
    }
}

extension Sizes {
    static let logoSize: CGFloat = 64
}
