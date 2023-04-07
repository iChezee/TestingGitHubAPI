import Foundation
import Combine

class RepositoriesSceneViewModel: ObservableObject {
    @DefaultNetworkService var network
    @DefaultFavoritesService var favourites
    
    @Published var repositories = [Repository]()
    @Published var selectedPeriod = SelectedPeriod.day {
        didSet {
            fetchRepositories()
        }
    }
    
    private var fetchedRepositories = [Repository]() {
        didSet {
            filterByFavouriteRepositories()
        }
    }
    private var isLoading = false
    private var currentPage = 1
    private var bunch = 20
    private var total = 0
    private var isFiltered = false {
        didSet {
            filterByFavouriteRepositories()
        }
    }
    private var searchText = ""
    
    init() {
        fetchRepositories()
    }
    
    func onSearchTextChanged(_ text: String) {
        // TODO: Debounced search
    }
    
    func onSearchTextSelected(_ text: String) {
        searchText = text
        fetchRepositories()
    }
    
    func onFavouriteTap(_ repository: Repository) {
        for (index, item) in repositories.enumerated() {
            if item.id == repository.id {
                repositories[index].isFavourite.toggle()
                favourites.toogleFavourite(item)
                break
            }
        }
    }
    
    func fetchNext() {
        if repositories.count < total && !isLoading {
            currentPage += 1
            fetchRepositories()
        }
    }
    
    func filterTapped() {
        isFiltered.toggle()
    }
}

private extension RepositoriesSceneViewModel {
    func fetchRepositories() {
        isLoading = true
        Task {
            let result = await network.fetchRepos(at: currentPage,
                                                  searchText: searchText,
                                                  period: selectedPeriod)
            DispatchQueue.main.sync { [weak self] in
                self?.isLoading = false
            }
            switch result {
            case .success(let response):
                total = response.total
                DispatchQueue.main.sync { [weak self] in
                    if let repos = self?.checkFavourites(response.repos) {
                        self?.fetchedRepositories.append(contentsOf: repos)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkFavourites(_ repositories: [Repository]) -> [Repository] {
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

enum SelectedPeriod: Int, Identifiable, CaseIterable {
    case day = 0
    case week
    case month
    
    var id: SelectedPeriod { self }
    
    var title: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        }
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        switch self {
        case .day:
            return dateFormatter.string(from: Date().addOrSubtractDay(day: -1))
        case .week:
            return dateFormatter.string(from: Date().addOrSubtractDay(day: -7))
        case .month:
            return dateFormatter.string(from: Date().addOrSubtractMonth(month: -1))
        }
    }
}
