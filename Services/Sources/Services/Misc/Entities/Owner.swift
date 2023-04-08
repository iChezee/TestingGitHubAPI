import Foundation

public struct Owner: Equatable, Identifiable, Codable {
    public let id: Int
    public let login: String
    public let avatar: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar = "avatar_url"
    }
}
