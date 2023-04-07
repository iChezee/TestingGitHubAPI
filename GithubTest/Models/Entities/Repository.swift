import Foundation

struct Repository: Hashable {
    let id: Int
    let name: String
    let owner: Owner
    let description: String?
    let starsCount: Int
    let language: String
    let forks: Int
    let creationDate: Date?
    let repoLink: URL
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        owner = try values.decode(Owner.self, forKey: .owner)
        description = try? values.decode(String.self, forKey: .description)
        starsCount = try values.decode(Int.self, forKey: .starsCount)
        language = try values.decode(String.self, forKey: .language)
        forks = try values.decode(Int.self, forKey: .forks)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        repoLink = try values.decode(URL.self, forKey: .repoLink)
    }
}
