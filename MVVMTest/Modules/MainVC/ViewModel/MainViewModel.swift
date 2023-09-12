import UIKit

//MARK: - MainViewModelProtocols
protocol MainViewModelProtocol: PostListDataSourceProtocol, PostsSortingProtocol, CellExpandingProtocol, MoreButtonHandling { }

protocol PostListDataSourceProtocol {
    func fetchPosts(completion: @escaping () -> Void)
    func numberOfPosts() -> Int
    func post(at index: Int) -> PostListItem
}

protocol PostsSortingProtocol {
    func sortPostsByDate()
    func sortPostsByRating()
}

protocol CellExpandingProtocol {
    func isCellExpanded(at index: Int) -> Bool
    func toggleCellExpansion(at index: Int)
}

protocol MoreButtonHandling {
    func moreButtonTapped(at indexPath: IndexPath, completion: @escaping (Result<DetailedPost, Error>) -> Void)
}

//MARK: - MainViewModel
class MainViewModel: MainViewModelProtocol {
    var posts: [PostListItem] = []
    var expandedIndexSet: IndexSet = []
    private var networkManager: NetworkManagerProtocol
    
    // MARK: - Initialization
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    //MARK: PostListDataSourceProtocol
    func fetchPosts(completion: @escaping () -> Void) {
        networkManager.fetchPosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let postList):
                self.posts = postList.posts
                completion()
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    func numberOfPosts() -> Int {
        return posts.count
    }
    
    func post(at index: Int) -> PostListItem {
        return posts[index]
    }
    
    //MARK: PostsSortingProtocol
    func sortPostsByDate() {
        posts.sort { $0.timeshamp > $1.timeshamp }
    }
    
    func sortPostsByRating() {
        posts.sort { $0.likesCount > $1.likesCount }
    }
    
    //MARK: CellExpandingProtocol
    func isCellExpanded(at index: Int) -> Bool {
        return expandedIndexSet.contains(index)
    }
    
    func toggleCellExpansion(at index: Int) {
        if(expandedIndexSet.contains(index)){
            expandedIndexSet.remove(index)
        } else {
            expandedIndexSet.insert(index)
        }
    }
    
    //MARK: MoreButtonHandling
    func moreButtonTapped(at indexPath: IndexPath, completion: @escaping (Result<DetailedPost, Error>) -> Void) {
        let postId = post(at: indexPath.row).postID
        
        networkManager.fetchPostDetails(postId: postId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let postDetails):
                    completion(.success(postDetails))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
