import Foundation

struct Owner: Hashable {
    let id: Int
    let login: String
    let avatar: URL
}

extension Owner: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
    }
}
