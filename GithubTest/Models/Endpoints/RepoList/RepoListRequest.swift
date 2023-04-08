import Foundation

struct RepoListRequest: Endpoint {
    var path: String = "/search/repositories"
    var method: HTTPMethod = .get
    var headers: [String: String]? = ["Accept": "application/json"]
    var queryParameters: [String: String]?
    var body: Data?
    
    init(page: Int, searchText: String, selectedPeriod: Period) {
        queryParameters = ["q": "\(searchText)+created:>\(selectedPeriod.date)",
                           "sort": "stars",
                           "order": "desc",
                           "per_page": "20",
                           "page": "\(page)"]
    }
}
