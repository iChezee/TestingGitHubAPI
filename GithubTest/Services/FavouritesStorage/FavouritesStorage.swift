import Foundation

protocol FavouritesStorage {
    func isFavourite(_ repo: Repository) -> Bool
    func toogleFavourite(_ repo: Repository)
    func eraseData()
}