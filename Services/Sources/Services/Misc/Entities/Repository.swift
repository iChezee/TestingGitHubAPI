import Foundation

public struct Repository: Equatable, Identifiable, Codable {
    public let id: Int
    public let name: String
    public let owner: Owner
    public let description: String?
    public let starsCount: Int
    public let language: String?
    public let forks: Int
    public let creationDate: Date
    public let repoLink: URL
    public var isFavourite = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case starsCount = "stargazers_count"
        case language
        case forks = "forks_count"
        case creationDate = "created_at"
        case repoLink = "html_url"
    }
    
    public static func ==(lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}
