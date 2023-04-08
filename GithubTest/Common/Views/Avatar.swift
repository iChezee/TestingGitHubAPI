import SwiftUI
import Services

struct Avatar: View {
    let owner: Owner
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: owner.avatar) { phase in // TODO: Cache images
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: size, height: size)
                    .cornerRadius(size / 2)
            default:
                GHImage.avatarPlaceholder.view
                    .resizable()
                    .frame(width: size, height: size)
                    .cornerRadius(size / 2)
            }
        }
    }
}
