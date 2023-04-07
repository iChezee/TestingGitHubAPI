import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParameters: [String: String]? { get }
    var body: Data? { get }
}

extension Endpoint {
    func makeUrl(scheme: String, host: String) -> URL {
        var components = URLComponents()
        let queryItems = queryParameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("This should never fail, check your endpoints setup, if a path is defined, make sure it starts with a / e.g. /search")
        }
        return url
    }
}
