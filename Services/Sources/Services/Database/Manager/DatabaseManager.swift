import RealmSwift
import Combine

public protocol DatabaseManager {
    var repositories: Published<[Repository]>.Publisher { get }
    var shortRepositories: Published<[ListRepository]>.Publisher { get }
    
    func add(_ object: Object)
    func add<S: Sequence>(_ objects: S) where S.Iterator.Element == Object
    func fetchRepositories(searchText: String, afterDate: String) async
}
