import Services

@propertyWrapper
struct DefaultNetworkService {
    public var wrappedValue: NetworkService { NetworkServiceImpl(scheme: "https", baseURL: "api.github.com")}
}

@propertyWrapper
struct DefaultFavoritesService {
    public var wrappedValue: FavouritesStorage { FavouritesStorageImpl() }
}
