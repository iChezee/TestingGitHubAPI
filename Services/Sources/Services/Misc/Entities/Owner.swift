import Foundation

public struct Owner: Equatable, Identifiable, Codable {
    public let id: Int
    public let login: String
    public let avatarURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
    }
}
