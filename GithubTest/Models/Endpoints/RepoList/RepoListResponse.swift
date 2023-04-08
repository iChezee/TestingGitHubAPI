import Foundation

struct RepoListResponse {
    let repos: [Repository]
    var nextPage: URL?
    var pagesCount: Int?
    
    init(repos: [Repository] = [Repository]()) {
        self.repos = repos
    }
}

extension RepoListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case repos = "items"
    }
}
