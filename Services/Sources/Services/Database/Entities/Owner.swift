import Foundation
import RealmSwift

public final class Owner: Object, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted public var login: String
    @Persisted public var avatarString: String
    public var avatarURL: URL {
        if let url = URL(string: avatarString) {
            return url
        } else {
            return URL(fileURLWithPath: "")
        }
    }
    
    convenience public init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.avatarString = try container.decode(String.self, forKey: .avatarString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarString = "avatar_url"
    }
}
