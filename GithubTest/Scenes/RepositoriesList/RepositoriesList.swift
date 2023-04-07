import SwiftUI

// TODO: Make cache for each tab

struct RepositoriesList: View {
    @DefaultFavoritesService var favourites
    @Binding var repositories: [Repository]
    var onFavouriteTap: (Repository) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Sizes.small) {
            ForEach(repositories) { repository in
                cellFor(repository)
                Divider()
            }
        }
    }
    
    func cellFor(_ repository: Repository) -> some View { // TODO: Open details on tap
        HStack {
            AsyncImage(url: repository.owner.avatar) { phase in // TODO: Cache images
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: Sizes.avatarImage, height: Sizes.avatarImage)
                        .cornerRadius(Sizes.avatarImage / 2)
                default:
                    GHImage.avatarPlaceholder.view
                        .resizable()
                        .frame(width: Sizes.avatarImage, height: Sizes.avatarImage)
                        .cornerRadius(Sizes.avatarImage / 2)
                }
            }
            .padding(Sizes.small)
            
            VStack(alignment: .leading, spacing: Sizes.small) {
                Text(repository.name)
                Text(repository.description ?? "")
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .padding(.horizontal, Sizes.small)
            
            ZStack {
                favourites.isFavourite(repository) ? GHIcons.favourite.view.resizable() :
                                                     GHIcons.unfavourite.view.resizable()
            }
            .frame(width: Sizes.favouriteImage, height: Sizes.favouriteImage)
            .onTapGesture {
                onFavouriteTap(repository)
            }
        }
    }
}

extension Sizes {
    static let avatarImage: CGFloat = 100
    static let favouriteImage: CGFloat = 50
}
