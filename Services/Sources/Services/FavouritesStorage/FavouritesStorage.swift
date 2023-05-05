import Foundation

public protocol FavouritesStorage {
    func isFavourite(_ repositoryID: Int) -> Bool
    func toogleFavourite(_ repositoryID: Int)
    func eraseData()
}
