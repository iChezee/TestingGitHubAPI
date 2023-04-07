import SystemConfiguration

enum Reachability {
    static func isConnectedToNetwork() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in(sin_len: 0,
                                      sin_family: 0,
                                      sin_port: 0,
                                      sin_addr: in_addr(s_addr: 0),
                                      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        guard let defaultRouteReachability = defaultRouteReachability else {
            return .unreachable
        }
        
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return .unreachable
        }
        
        var isReachable = flags == .reachable
        var needsConnection = flags == .connectionRequired
        
        if isReachable && !needsConnection {
            return .wifi
        }
        
        isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? .wwan : .unreachable
    }
}
