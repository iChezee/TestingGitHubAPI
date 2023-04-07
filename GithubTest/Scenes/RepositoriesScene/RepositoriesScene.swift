import SwiftUI

struct RepositoriesScene: View {
    
    @ObservedObject var viewModel = RepositoriesSceneViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: Sizes.medium) {
                HStack {
                    Spacer()
                    GHIcons.filter.view
                        .resizable()
                        .frame(width: Sizes.large, height: Sizes.large)
                        .padding(.trailing, Sizes.medium)
                        .onTapGesture {
                            viewModel.filterTapped()
                        }
                }
                .padding(.bottom, -Sizes.large)
                GHImage.ghLogo.view
                    .resizable()
                    .frame(width: Sizes.logoSize, height: Sizes.logoSize)
                    .background(GHColor.background.view)
                periodPicker
                SearchBar(onSearchChanged: ( viewModel.onSearchTextChanged ),
                          onSearchTapped: ( viewModel.onSearchTextSelected ),
                          onEraseTapped: { viewModel.onSearchTextSelected("") })
                mainList
            }
            .padding(.top, Sizes.medium)
            .padding(.horizontal, Sizes.medium)
        }
        .background(GHColor.background.view.ignoresSafeArea())
    }
    
    var periodPicker: some View {
        Picker("", selection: $viewModel.selectedPeriod) {
            ForEach(SelectedPeriod.allCases, id: \.self) {
                Text($0.title)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var mainList: some View {
        RepositoriesList(repositories: $viewModel.repositories) {
            viewModel.onFavouriteTap($0)
        }
    }
}

extension Sizes {
    static let logoSize: CGFloat = 64
}
