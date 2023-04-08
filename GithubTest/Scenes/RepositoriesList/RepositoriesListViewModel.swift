import Foundation
import Services

class RepositoriesListViewModel: ObservableObject {
    @DefaultNetworkService var network
    @DefaultFavoritesService var favourites
    
    @Published var repositories = [Repository]()
    @Published var selectedRepository: Repository?
    
    private var period: Period
    private var fetchedRepositories = [Repository]() {
        didSet {
            filterByFavouriteRepositories()
        }
    }
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
        fetchRepositories(additional: false)
    }
    
    func onSearchTextChanged(_ text: String) {
        searchText = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if !(self?.isLoading ?? true) {
                self?.fetchRepositories(additional: false)
            }
        }
    }
    
    func isFavourite(_ repository: Repository) -> Bool {
        favourites.isFavourite(repository)
    }
    
    func onFavouriteTap(_ repository: Repository) {
        for (index, item) in fetchedRepositories.enumerated() {
            if item.id == repository.id {
                fetchedRepositories[index].isFavourite.toggle()
                favourites.toogleFavourite(item)
                break
            }
        }
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
}

private extension RepositoriesListViewModel {
    func fetchRepositories(additional: Bool) {
        isLoading = true
        Task {
            let result = await network.fetchRepos(at: currentPage,
                                                  searchText: searchText,
                                                  afterDate: period.date)
            DispatchQueue.main.sync { [weak self] in
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                totalPages = response.pagesCount ?? 1
                DispatchQueue.main.sync { [weak self] in
                    guard let repos = self?.setFavourites(response.repos) else {
                        return
                    }
                    if additional {
                        self?.fetchedRepositories.append(contentsOf: repos)
                    } else {
                        self?.fetchedRepositories = repos
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setFavourites(_ repositories: [Repository]) -> [Repository] {
        var repos = [Repository]()
        for repository in repositories {
            var repo = repository
            repo.isFavourite = favourites.isFavourite(repository)
            repos.append(repo)
        }
        
        return repos
    }
    
    func filterByFavouriteRepositories() {
        repositories = isFiltered ? fetchedRepositories.filter { $0.isFavourite } : fetchedRepositories
    }
}
