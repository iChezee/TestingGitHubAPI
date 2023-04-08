import Foundation

public struct Owner: Hashable {
    public let id: Int
    public let login: String
    public let avatar: URL
}

extension Owner: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
    }
}
