import Foundation

protocol NetworkService {
    func fetchRepos(at page: Int, searchText: String, period: SelectedPeriod) async -> Result<RepoListResponse, NetworkError>
}

@propertyWrapper
struct DefaultNetworkService {
    var wrappedValue: NetworkService { NetworkServiceImpl(scheme: "https", baseURL: "api.github.com")}
}

public enum NetworkError: LocalizedError {
    case decoding(Error)
    case transportError(Error)
    case serverSideError(Int)
    case invalidLink
    case unathorized
    case noInternet(ReachabilityStatus)
    case notHTTPResponse(URLResponse)
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .decoding:
            return "Decoding error"
        case .transportError:
            return "Transport error"
        case .serverSideError:
            return "Server side error"
        case .invalidLink:
            return "Link is invalid"
        case .unathorized:
            return "Unathorized"
        case .noInternet:
            return "No connection"
        case .notHTTPResponse:
            return "Response invalid"
        case .unknown:
            return "Unknown issue"
        }
    }
}

public enum ReachabilityStatus: String {
    case unreachable, wifi, wwan
}
