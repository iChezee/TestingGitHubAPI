import Foundation
import RealmSwift

public class ListRepository: Projection<Repository> {
    @Projected(\Repository.id) public var id: Int
    @Projected(\Repository.name) public var name: String
    @Projected(\Repository.owner?.avatarURL) public var avatarURL: URL?
    @Projected(\Repository.info) public var info: String?
    @Projected(\Repository.forks) public var forks: Int
    @Projected(\Repository.isFavourite) public var isFavourite: Bool
}
