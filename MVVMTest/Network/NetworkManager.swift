import Foundation
import UIKit


protocol NetworkManagerProtocol {
    func fetchPosts(completion: @escaping (Result<PostList, Error>) -> Void)
    func fetchPostDetails(postId: Int, completion: @escaping (Result<DetailedPost, Error>) -> Void)
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

//MARK: - NetworkManager
class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Fetch Posts
    func fetchPosts(completion: @escaping (Result<PostList, Error>) -> Void) {
        if let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let postList = try decoder.decode(PostList.self, from: data)
                        completion(.success(postList))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Fetch Post Details
    func fetchPostDetails(postId: Int, completion: @escaping (Result<DetailedPost, Error>) -> Void) {
        if let url = URL(string: "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(postId).json") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let post = try decoder.decode(PostResponse.self, from: data)
                        let postDetails = post.post
                        completion(.success(postDetails))
                    } catch {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    // MARK: - Fetch Image
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let image = UIImage(data: data)
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}


