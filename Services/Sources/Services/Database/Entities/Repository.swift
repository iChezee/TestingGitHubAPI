import Foundation
import RealmSwift

public final class Repository: Object {
    @Persisted(primaryKey: true) public var id: Int
    @Persisted public var name: String
    @Persisted public var owner: Owner?
    @Persisted public var info: String?
    @Persisted public var starsCount: Int
    @Persisted public var language: String?
    @Persisted public var forks: Int
    @Persisted public var creationDate: Date
    @Persisted public var repoLink: String
    @Persisted public var isFavourite = false
    
    convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.owner = try container.decode(Owner.self, forKey: .owner)
        self.info = try? container.decode(String.self, forKey: .description)
        self.starsCount = try container.decode(Int.self, forKey: .starsCount)
        self.language = try? container.decode(String.self, forKey: .language)
        self.forks = try container.decode(Int.self, forKey: .forks)
        self.creationDate = try container.decode(Date.self, forKey: .creationDate)
        self.repoLink = try container.decode(String.self, forKey: .repoLink)
    }
}

extension Repository: Decodable {
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
}
