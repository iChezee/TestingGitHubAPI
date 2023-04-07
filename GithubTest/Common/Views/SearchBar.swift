import SwiftUI

struct SearchBar: View {
    @State var showCancelButton = false
    @State var searchText = "" {
        didSet {
            onSearchChanged(searchText)
        }
    }
    
    var onSearchChanged: (_ searchText: String) -> Void
    var onSearchTapped: (_ searchText: String) -> Void
    var onEraseTapped: () -> Void
    
    var body: some View {
        HStack(spacing: Sizes.small) {
            ZStack {
                RoundedRectangle(cornerRadius: Sizes.small)
                    .stroke(Color.gray, lineWidth: Sizes.strokeSize)
                TextField("Search",
                          text: $searchText,
                          onEditingChanged: { isEditing in
                    if !isEditing && !searchText.isEmpty {
                        onSearchChanged(searchText)
                    }
                    self.showCancelButton = isEditing
                }, onCommit: {
                    onSearchTapped(searchText)
                })
                .padding(.horizontal, Sizes.small)
            }
            
            if showCancelButton {
                Button(action: {
                    searchText = ""
                    onEraseTapped()
                    UIApplication.shared.endEditing()
                }, label: {
                    GHIcons.erase.view
                        .resizable()
                        .frame(width: Sizes.medium, height: Sizes.medium)
                })
            }
        }
        .frame(height: Sizes.height)
    }
}

fileprivate extension Sizes {
    static let height: CGFloat = 40
}

fileprivate extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
