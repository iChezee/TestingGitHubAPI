import Realm
import RealmSwift
import Combine

public class DatabaseManagerImpl: ObservableObject {
    @Published var allRepositories = [Repository]()
    @Published var projectedShortRepositories = [ListRepository]()
    
    public var repositories: Published<[Repository]>.Publisher {
        $allRepositories
    }
    
    public var shortRepositories: Published<[ListRepository]>.Publisher {
        $projectedShortRepositories
    }
    
    private(set) var localDatabase: Realm?
    private let networkService: NetworkService
    
    public init(networkService: NetworkService, databaseURL: String? = nil) {
        self.networkService = networkService
        openRealm()
        fetchRepositories()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            Realm.Configuration.defaultConfiguration = config
            let database = try Realm()
            localDatabase = database
            allRepositories = database.objects(Repository.self).map { $0 }
            projectedShortRepositories = allRepositories.map { .init(projecting: $0) }
        } catch {
            print("Error opening Realm", error)
        }
    }
}

extension DatabaseManagerImpl: DatabaseManager {
    public func add(_ object: Object) {
        if let localDatabase = localDatabase {
            do {
                try localDatabase.write {
                    localDatabase.add(object)
                }
            } catch {
                print("Error adding: \(object)")
            }
        }
    }
    
    public func add<S: Sequence>(_ objects: S) where S.Iterator.Element == Object {
        if let localDatabase = localDatabase {
            do {
                try localDatabase.write {
                    localDatabase.add(objects)
                }
            } catch {
                print("Error adding: \(objects)")
            }
        }
    }
    
    public func fetchRepositories(searchText: String =  "", afterDate: String = Date().ISO8601Format(.iso8601)) {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            let result = await self.networkService.fetchRepos(at: 1, searchText: searchText, afterDate: afterDate)
            switch result {
            case .success(let response):
                self.allRepositories.append(contentsOf: response.repos)
            case .failure(let error):
                print(error)
            }
        }
    }
}
