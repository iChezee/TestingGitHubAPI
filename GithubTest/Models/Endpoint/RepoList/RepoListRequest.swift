import Foundation

struct RepoListRequest: Endpoint {
    var path: String = "/search/repositories"
    var method: HTTPMethod = .get
    var headers: [String: String]? = ["Accept": "application/json"]
    var queryParameters: [String: String]?
    var body: Data?
    
    init(page: Int = 1, searchText: String = "", language: Language = .swift) {
        queryParameters = ["q": "\(searchText)+language:\(language.rawValue)",
                           "sort": "stars",
                           "order": "desc",
                           "per_page": "20",
                           "page": "\(page)"]
    }
}

extension RepoListRequest {
    enum Language: String {
        case swift
        case objectiveC = "objective-c"
    }
}
