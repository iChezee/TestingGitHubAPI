import SwiftUI
import Services
import CachedAsyncImage

struct Avatar: View {
    let avatarURL: URL
    let size: CGFloat
    
    init(_ avatarURL: URL, size: CGFloat) {
        self.avatarURL = avatarURL
        self.size = size
    }
    
    var body: some View {
        CachedAsyncImage(url: avatarURL) { phase in
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
