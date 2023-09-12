import UIKit

struct ModuleBuilder {
    static func buildMainVC() -> UIViewController {
        let networkManager = NetworkManager()
        let mainViewModel = MainViewModel(networkManager: networkManager)
        let mainViewController = MainViewController(viewModel: mainViewModel)
        return mainViewController
    }
    
    static func buildDetailVC(post: DetailedPost) -> UIViewController {
        let networkManager = NetworkManager()
        let detailViewModel = DetailViewModel(postDetails: post, networkManager: networkManager)
        let detailViewController = DetailViewController(viewModel: detailViewModel)
        return detailViewController
    }
}
