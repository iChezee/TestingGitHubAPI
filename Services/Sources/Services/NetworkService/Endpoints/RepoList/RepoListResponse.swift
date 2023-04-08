import Foundation

public struct RepoListResponse {
    public let repos: [Repository]
    public var nextPage: URL?
    public var pagesCount: Int?
    
    init(repos: [Repository] = [Repository]()) {
        self.repos = repos
    }
}

extension RepoListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case repos = "items"
    }
}
