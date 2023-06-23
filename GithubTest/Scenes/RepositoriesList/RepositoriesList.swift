import SwiftUI
import Services

struct RepositoriesList: View {
    @ObservedObject var viewModel: RepositoriesListViewModel
    @State private var searchText: String = ""
    @State private var detailsPresented = false
    
    @State private var verticalOffset: CGFloat = 0.0
    @State private var totalHeight: CGFloat = 0
    
    var body: some View {
        VStack(spacing: Sizes.medium) {
            searchBar
            if viewModel.repositories.isEmpty {
                initialLoadingView
            }
            loadedView
        }
        .frame(maxHeight: .infinity)
    }
    
    var initialLoadingView: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, Sizes.small)
            } else {
                Text("There is no repos for today")
            }
        }
    }
    
    var loadedView: some View {
        OffsettableScrollView { point in
            verticalOffset = point.y
        } content: {
            ForEach(viewModel.repositories) {
                cellFor($0)
                Divider()
            }
            if viewModel.isLoading && !viewModel.repositories.isEmpty {
                ProgressView()
                    .padding(.top, Sizes.small)
            }
        }
        .onChange(of: verticalOffset) { newValue in
            fetchNextIfNeeded(newValue)
        }
        .onChange(of: viewModel.repositories) { newValue in
            totalHeight = calculateHeightFor(itemsCount: newValue.count)
        }
    }
    
    var searchBar: some View {
        HStack(spacing: Sizes.small) {
            ZStack {
                RoundedRectangle(cornerRadius: Sizes.small)
                    .stroke(Color.gray, lineWidth: Sizes.strokeSize)
                TextField("Search", text: $searchText)
                    .padding(.horizontal, Sizes.small)
            }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    UIApplication.shared.endEditing()
                }, label: {
                    GHIcons.erase.view
                        .resizable()
                        .frame(width: Sizes.medium, height: Sizes.medium)
                })
            }
            
            Button(action: viewModel.filterTapped) {
                GHIcons.filter.view
                    .resizable()
                    .frame(width: Sizes.medium, height: Sizes.medium)
            }
        }
        .frame(height: Sizes.searchHeight)
        .onChange(of: searchText) { newValue in
            viewModel.onSearchTextChanged(newValue)
        }
    }
}

private extension RepositoriesList {
    func cellFor(_ repository: Repository) -> some View {
        HStack {
            Avatar(repository.owner.avatarURL, size: Sizes.avatarImage)
                .padding(Sizes.small)
            
            VStack(alignment: .leading, spacing: Sizes.small) {
                Text(repository.name)
                Text(repository.description ?? "")
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .padding(.horizontal, Sizes.small)
            Spacer()
            favouritesStack(repository)
        }
        .onTapGesture {
            viewModel.selectedRepository = repository
            withAnimation(.easeOut) {
                detailsPresented.toggle()
            }
        }
        .sheet(isPresented: $detailsPresented) {
            DetailsScene(isPresented: $detailsPresented,
                         repository: viewModel.selectedRepository!,
                         onFavouriteTap: viewModel.onFavouriteTap)
        }
    }
    
    func favouritesStack(_ repository: Repository) -> some View {
        VStack {
            VStack {
                GHIcons.favourite.view
                    .resizable()
                    .frame(width: Sizes.small, height: Sizes.small)
                Text("\(repository.forks)")
            }
            
            ZStack {
                viewModel.isFavourite(repository) ? GHIcons.favourite.view.resizable() :
                GHIcons.unfavourite.view.resizable()
            }
            .frame(width: Sizes.large, height: Sizes.large)
            .onTapGesture {
                viewModel.onFavouriteTap(repository)
            }
        }
    }
    
    func fetchNextIfNeeded(_ offset: CGFloat) {
        if offset + totalHeight < 200 {
            viewModel.loadNext()
        }
    }
    
    func calculateHeightFor(itemsCount: Int) -> CGFloat {
        CGFloat(itemsCount - 5) * (Sizes.avatarImage + (Sizes.small * 2))
    }
}

fileprivate extension Sizes {
    static let searchHeight: CGFloat = 40
    static let avatarImage: CGFloat = 100
    static let favouritesStackWidth: CGFloat = 32
    static let favouriteImage: CGFloat = 24
}

fileprivate extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
