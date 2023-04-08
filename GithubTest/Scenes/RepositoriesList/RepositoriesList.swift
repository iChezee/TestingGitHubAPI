import SwiftUI

// TODO: Make cache for each tab

struct RepositoriesList: View {
    @DefaultFavoritesService var favourites
    
    @Binding var repositories: [Repository]
    @State private var selectedRepository: Repository?
    @State private var detailsPresented = false
    
    let onLoadMore: () -> Void
    let onFavouriteTap: (Repository) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.small) {
            ForEach(repositories) { repository in
                cellFor(repository)
                Divider()
            }
        }
    }
    
    func cellFor(_ repository: Repository) -> some View {
        HStack {
            Avatar(owner: repository.owner, size: Sizes.avatarImage)
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
            handleTap(repository)
        }
        .sheet(isPresented: $detailsPresented) {
            DetailsScene(isPresented: $detailsPresented,
                         repository: selectedRepository!,
                         onFavouriteTap: onFavouriteTap)
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
                favourites.isFavourite(repository) ? GHIcons.favourite.view.resizable() :
                GHIcons.unfavourite.view.resizable()
            }
            .frame(width: Sizes.large, height: Sizes.large)
            .onTapGesture {
                onFavouriteTap(repository)
            }
        }
    }
    
    func handleTap(_ repository: Repository) {
        selectedRepository = repository
        withAnimation(.easeOut) {
            detailsPresented.toggle()
        }
    }
}

fileprivate extension Sizes {
    static let avatarImage: CGFloat = 100
    static let favouritesStackWidth: CGFloat = 32
    static let favouriteImage: CGFloat = 24
}
