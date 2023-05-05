import Foundation
import Services
import Combine

class RepositoriesListViewModel: ObservableObject {
    @DefaultDatabase var database
    @DefaultFavoritesService var favourites
    
    @Published var repositories: [ListRepository] = [ListRepository]()
    @Published var selectedRepository: Repository?
    
    private var period: Period
    private var fetchedRepositories: [ListRepository] = [ListRepository]() {
        didSet {
            filterByFavouriteRepositories()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private var isLoading = false
    private var currentPage = 1
    private var totalPages = 0
    private var searchText = ""
    private var isFiltered = false {
        didSet {
            filterByFavouriteRepositories()
        }
    }
    
    init(period: Period) {
        self.period = period
        subscribe()
        Task {
            await database.fetchRepositories(searchText: searchText, afterDate: period.date)
        }
    }
    
    func subscribe() {
        database.shortRepositories
            .receive(on: DispatchQueue.main)
            .sink { listRepositories in
                self.repositories = listRepositories
            }
            .store(in: &cancellables)
    }
    
    func onSearchTextChanged(_ text: String) {
        searchText = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if !(self?.isLoading ?? true) {
                self?.fetchRepositories(additional: false)
            }
        }
    }
    
    func isFavourite(_ repository: ListRepository) -> Bool {
        favourites.isFavourite(repository.id)
    }
    
    func onFavouriteTap(_ repository: ListRepository) {
        repository.isFavourite = true
        favourites.toogleFavourite(repository.id)
    }
    
    func loadNext() {
        if currentPage < totalPages && !isLoading && !isFiltered {
            currentPage += 1
            fetchRepositories(additional: true)
        }
    }
    
    func filterTapped() {
        isFiltered.toggle()
    }
    
    func getFullRepository(with short: ListRepository) {
        database.repositories
            .receive(on: OperationQueue.main)
            .sink { value in
                self.selectedRepository = value.first(where: { $0.id == short.id })
            }
            .store(in: &cancellables)
    }
}

private extension RepositoriesListViewModel {
    func fetchRepositories(additional: Bool) {
        isLoading = true
        Task {
            await database.fetchRepositories(searchText: searchText, afterDate: period.date)
            DispatchQueue.main.sync { [weak self] in
                self?.isLoading = false
            }
//            switch result {
//            case .success(let response):
//                totalPages = response.pagesCount ?? 1
//                DispatchQueue.main.sync { [weak self] in
//                    guard let repos = self?.setFavourites(response.repos) else {
//                        return
//                    }
//                    if additional {
//                       self?.fetchedRepositories.append(contentsOf: repos)
//                    } else {
//                        self?.fetchedRepositories = repos
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
        }
    }
    
    func setFavourites(_ repositories: [Repository]) -> [Repository] {
        var repos = [Repository]()
        for repository in repositories {
            repository.isFavourite = favourites.isFavourite(repository.id)
            repos.append(repository)
        }
        
        return repos
    }
    
    func filterByFavouriteRepositories() {
        repositories = isFiltered ? fetchedRepositories.filter { $0.isFavourite } : fetchedRepositories
    }
}
