import XCTest
@testable import Services

final class EndpointTests: XCTestCase {
    var testEndpoint: TestEndpoint?
    
    override func setUpWithError() throws {
        testEndpoint = TestEndpoint()
    }
    
    override func tearDownWithError() throws {
        testEndpoint = nil
    }
    
    func testEndpointMakeUrl() throws {
        let host = "github.com"
        let scheme = "https"
        guard let url = testEndpoint?.makeUrl(scheme: scheme, host: host) else {
            throw CocoaError(.keyValueValidation)
        }
        
        XCTAssert(url.absoluteString == "https://github.com/test?username=jonny")
    }
    
    func testEndpointMakeUrlQueryItemEncoding() throws {
        let host = "github.com"
        let scheme = "https"
        testEndpoint?.queryParameters = ["username": "jonny appleseed"]
        guard let url = testEndpoint?.makeUrl(scheme: scheme, host: host) else {
            throw CocoaError(.keyValueValidation)
        }
        
        XCTAssert(url.absoluteString == "github.com/test?username=jonny%20appleseed")
    }
}

extension EndpointTests {
    struct TestEndpoint: Endpoint {
        var path = "/test"
        var method = HTTPMethod.get
        var queryParameters: [String : String]? = ["username": "jonny"]
        var headers: [String : String]? = ["X-Tally-Header": "Test header"]
        var body: Data?
    }
}
