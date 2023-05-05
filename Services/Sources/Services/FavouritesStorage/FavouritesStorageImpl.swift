import Foundation

public class FavouritesStorageImpl: FavouritesStorage {
    private var favouriteRepos = Set<Int>()
    private let localStorageSaveKey = "LocalStorageSaveKey"
    
    public init() {
        if let favourites = UserDefaults.standard.object(forKey: localStorageSaveKey) as? [String] {
            favouriteRepos = Set(favourites.compactMap { Int($0) })
        }
    }
    
    public func isFavourite(_ repositoryID: Int) -> Bool {
        favouriteRepos.contains(repositoryID)
    }
    
    public func toogleFavourite(_ repositoryID: Int) {
        if favouriteRepos.first(where: { $0 == repositoryID }) != nil {
            favouriteRepos.remove(repositoryID)
        } else {
            favouriteRepos.insert(repositoryID)
        }
        
        saveData()
    }
    
    public func saveData() {
        let favourites = favouriteRepos.map { "\($0)" }
        UserDefaults.standard.set(favourites, forKey: localStorageSaveKey)
    }
    
    public func eraseData() {
        favouriteRepos.removeAll()
        if UserDefaults.standard.value(forKey: localStorageSaveKey) != nil {
            UserDefaults.standard.set([String](), forKey: localStorageSaveKey)
        }
    }
}
