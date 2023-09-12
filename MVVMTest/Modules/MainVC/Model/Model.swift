import Foundation

// MARK: - PostList
struct PostList: Codable {
    let posts: [PostListItem]
}

// MARK:  PostListItem
struct PostListItem: Codable, Equatable {
    let postID, timeshamp: Int
    let title, previewText: String
    let likesCount: Int
    
    static func == (lhs: PostListItem, rhs: PostListItem) -> Bool {
        return lhs.postID == rhs.postID &&
        lhs.title == rhs.title &&
        lhs.timeshamp == rhs.timeshamp &&
        lhs.likesCount == rhs.likesCount
    }

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

// MARK: - PostResponse
struct PostResponse: Codable {
    let post: DetailedPost
}

// MARK:  DetailedPost
struct DetailedPost: Codable {
    let postID, timeshamp: Int
    let title, text: String
    let postImage: String
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title, text, postImage
        case likesCount = "likes_count"
    }
}

