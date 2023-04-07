import Foundation

class FavouritesStorageImpl: FavouritesStorage {
    private var favouriteRepos = Set<Int>()
    private let localStorageSaveKey = "LocalStorageSaveKey"
    
    init() {
        if let favourites = UserDefaults.standard.object(forKey: localStorageSaveKey) as? [String] {
            favouriteRepos = Set(favourites.compactMap { Int($0) })
        }
    }
    
    func isFavourite(_ repo: Repository) -> Bool {
        favouriteRepos.contains(repo.id)
    }
    
    func toogleFavourite(_ repository: Repository) {
        let repositoryID = repository.id
        if favouriteRepos.first(where: { $0 == repositoryID }) != nil {
            favouriteRepos.remove(repositoryID)
        } else {
            favouriteRepos.insert(repositoryID)
        }
        
        saveData()
    }
    
    func saveData() {
        let favourites = favouriteRepos.map { "\($0)" }
        UserDefaults.standard.set(favourites, forKey: localStorageSaveKey)
    }
    
    func eraseData() {
        favouriteRepos.removeAll()
        if UserDefaults.standard.value(forKey: localStorageSaveKey) != nil {
            UserDefaults.standard.set([String](), forKey: localStorageSaveKey)
        }
    }
}
