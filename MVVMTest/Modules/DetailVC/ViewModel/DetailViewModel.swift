import Foundation
import UIKit

// MARK: - DetailViewModelProtocol
protocol DetailViewModelProtocol {
    var postDetails: DetailedPost { get set }
    func loadImage(completion: @escaping (Result<UIImage?, Error>) -> Void)
}

// MARK: - DetailViewModel
class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Properties
    var postDetails: DetailedPost
    private var networkManager: NetworkManagerProtocol
    // MARK: - Initialization
    init(postDetails: DetailedPost, networkManager: NetworkManagerProtocol) {
        self.postDetails = postDetails
        self.networkManager = networkManager
    }
    
    // MARK: - Image Loading
    func loadImage(completion: @escaping (Result<UIImage?, Error>) -> Void) {
        guard let imageURL = URL(string: postDetails.postImage) else { return }
        
        networkManager.fetchImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
