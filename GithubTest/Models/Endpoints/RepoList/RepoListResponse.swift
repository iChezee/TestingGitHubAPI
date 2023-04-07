import Foundation

struct RepoListResponse {
    let total: Int
    let repos: [Repository]
    
    init(total: Int = 0, repos: [Repository] = [Repository]()) {
        self.total = total
        self.repos = repos
    }
}

extension RepoListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case total = "total_count"
        case repos = "items"
    }
}
