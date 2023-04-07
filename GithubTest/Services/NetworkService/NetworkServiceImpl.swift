import Foundation
import Combine

class NetworkServiceImpl {
    private let session = URLSession(configuration: .default)
    private let decoder = JSONDecoder()
    let scheme: String
    let baseURL: String
    
    init(scheme: String, baseURL: String) {
        self.scheme = scheme
        self.baseURL = baseURL
        self.decoder.dateDecodingStrategy = .iso8601
    }
}

extension NetworkServiceImpl: NetworkService {
    func fetchRepos(at page: Int = 1, searchText: String = "") async -> Result<RepoListResponse, Error> {
        if let noInternet = checkInternet() {
            return .failure(noInternet)
        }
        
        let reqeust = makeRequest(RepoListRequest(page: page, searchText: searchText))
        do {
            let (data, response) = try await session.data(for: reqeust)
            if let error = checkForResponseErrors(response: response) {
                return .failure(error)
            }
            
            if !data.isEmpty {
                let decoded = try decoder.decode(RepoListResponse.self, from: data)
                return .success(decoded)
            } else {
                return .failure(NetworkError.unknown)
            }
        } catch {
            return .failure(NetworkError.decoding)
        }
    }
}

private extension NetworkServiceImpl {
    func checkInternet() -> NetworkError? {
        let reachability = Reachability.isConnectedToNetwork()
        if case .unreachable = reachability {
            return .noInternet(reachability)
        }
        
        return nil
    }
    
    func checkForResponseErrors(response: URLResponse) -> NetworkError? {
        guard let response = response as? HTTPURLResponse else {
            return .notHTTPResponse(response)
        }
        let status = response.statusCode
        
        guard status != 200 else {
            return nil
        }
        
        if status == 401 {
            return .unathorized
        }
        
        if (400...999).contains(status) {
            return .serverSideError(status)
        }
        
        return .unknown
    }
    
    func makeRequest(_ endpoint: Endpoint) -> URLRequest {
        let url = endpoint.makeUrl(scheme: scheme, host: baseURL)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        return request
    }
}
