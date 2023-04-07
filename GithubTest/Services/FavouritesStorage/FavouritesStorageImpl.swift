import Foundation

class FavouritesStorageImpl: FavouritesStorage {
    private var favouriteRepos = Set<String>()
    private let localStorageSaveKey = "LocalStorageSaveKey"
    
    init() {
        if let favourites = UserDefaults.standard.object(forKey: localStorageSaveKey) as? [String] {
            favouriteRepos = Set(favourites)
        }
    }
    
    func isFavourite(_ repo: Repository) -> Bool {
        favouriteRepos.contains(repo.name)
    }
    
    func toogleFavourite(_ repo: Repository) {
        let repoName = repo.name
        if favouriteRepos.first(where: { $0 == repoName }) != nil {
            favouriteRepos.remove(repoName)
        } else {
            favouriteRepos.insert(repoName)
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
