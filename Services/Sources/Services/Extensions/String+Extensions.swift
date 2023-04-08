import Foundation

extension String {
    func trimWhitespacesAndSymbols() -> String {
        trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .symbols)
    }
}
