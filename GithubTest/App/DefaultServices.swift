import Services

@propertyWrapper
struct DefaultDatabase {
    public var wrappedValue: DatabaseManager {
        let networkService = NetworkServiceImpl(scheme: "https", baseURL: "api.github.com")
        return DatabaseManagerImpl(networkService: networkService)
    }
}

@propertyWrapper
struct DefaultFavoritesService {
    public var wrappedValue: FavouritesStorage { FavouritesStorageImpl() }
}
