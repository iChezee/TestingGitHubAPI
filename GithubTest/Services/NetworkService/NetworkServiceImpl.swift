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
    func fetchRepos(at page: Int, searchText: String, period: Period) async -> Result<RepoListResponse, NetworkError> {
        if let noInternet = checkInternet() {
            return .failure(noInternet)
        }
        
        let request = makeRequest(RepoListRequest(page: page, searchText: searchText, selectedPeriod: period))
        let result = await executeRequest(request, response: RepoListResponse.self)
        if case .success(let executed) = result {
            var decoded = executed.decoded
            let response = executed.response
            extractAdditionalFieldsFor(&decoded, response: response)
            return .success(decoded)
        } else if case .failure(let failure) = result {
            return .failure(failure)
        } else {
            return .failure(.unknown)
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
    
    func makeRequest(_ endpoint: Endpoint) -> URLRequest {
        let url = endpoint.makeUrl(scheme: scheme, host: baseURL)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        return request
    }
    
    func executeRequest<Response>(_ urlRequest: URLRequest, response: Response.Type) async -> Result<(decoded: Response, response: HTTPURLResponse), NetworkError> where Response: Decodable {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.notHTTPResponse(response))
            }
            
            if let error = checkForResponseErrors(response: response) {
                return .failure(error)
            }
            
            if !data.isEmpty {
                let decoded = try decoder.decode(Response.self, from: data)
                return .success((decoded, response))
            } else {
                return .failure(NetworkError.unknown)
            }
        } catch {
            return .failure(NetworkError.decoding(error))
        }
    }
    
    func checkForResponseErrors(response: HTTPURLResponse) -> NetworkError? {
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
    
    func extractAdditionalFieldsFor(_ repoList: inout RepoListResponse, response: HTTPURLResponse) {
        let fields = response.allHeaderFields
        guard let link = fields["Link"] as? String else {
            return
        }
        let components = link.components(separatedBy: ",")
        
        if let last = components.first(where: { $0.contains("last") })?
                                .components(separatedBy: ";").first?
                                .trimWhitespacesAndSymbols(),
           let parameters = URL(string: last)?.queryParameters,
           let pagesCount = parameters["page"] {
            repoList.pagesCount = Int(pagesCount)
        }
    }
}
