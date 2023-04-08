import SwiftUI
import Services

struct DetailsScene: View {
    @DefaultFavoritesService var favourites
    
    var isPresented: Binding<Bool>
    @State var repository: Repository
    let onFavouriteTap: (Repository) -> Void
    
    var body: some View {
        VStack(spacing: Sizes.medium) {
            HStack {
                Button {
                    isPresented.wrappedValue.toggle()
                } label: {
                    GHIcons.erase.view
                        .resizable()
                        .frame(width: Sizes.medium, height: Sizes.medium)
                }
                .padding(.leading, Sizes.large)
                
                Spacer()
                
                ZStack {
                    favourites.isFavourite(repository) ? GHIcons.favourite.view.resizable() :
                                                         GHIcons.unfavourite.view.resizable()
                }
                .frame(width: Sizes.large, height: Sizes.large)
                .padding(.trailing, Sizes.large)
                .onTapGesture {
                    var repository = repository
                    repository.isFavourite.toggle()
                    self.repository = repository
                    onFavouriteTap(repository)
                }
            }
            .padding(.top, Sizes.large)
            
            Avatar(owner: repository.owner, size: Sizes.avatarSize)
            infoStack(repository).padding(.horizontal, Sizes.small)

            Spacer()
        }
        .background(GHColor.background.view)
    }
    
    func infoStack(_ repository: Repository) -> some View {
        VStack(spacing: Sizes.medium) {
            Text(repository.name)
            if let description = repository.description {
                Text("Description:\n\(description)")
            }
            if let language = repository.language {
                Text("Language: \(language)")
            }
            Text("Forks count: \(repository.forks)")
            Text("Created: \(repository.creationDate.toString())")
            Link("Github repository link", destination: repository.repoLink)
        }
        .multilineTextAlignment(.center)
    }
}

fileprivate extension Sizes {
    static let avatarSize: CGFloat = 192
}
