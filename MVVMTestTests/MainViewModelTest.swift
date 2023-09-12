//
//  MainViewModelTest.swift
//  MVVMTestTests
//
//  Created by Zabroda Gleb on 12.09.2023.
//

import XCTest
@testable import MVVMTest

class MockNetworkManager: NetworkManagerProtocol {
    var postsResult: Result<PostList, Error>?
    var postDetailsResult: Result<DetailedPost, Error>?
    
    func fetchPosts(completion: @escaping (Result<PostList, Error>) -> Void) {
        if let result = postsResult {
            completion(result)
        }
    }
    
    func fetchPostDetails(postId: Int, completion: @escaping (Result<DetailedPost, Error>) -> Void) {
        if let result = postDetailsResult {
            completion(result)
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        let fakeImage: UIImage? = nil
        completion(.success(fakeImage))
    }
}

final class MainViewModelTest: XCTestCase {
    var viewModel: MainViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = MainViewModel(networkManager: mockNetworkManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testToggleCellExpansion() {
        let initialExpandedIndexSet = viewModel.expandedIndexSet
        
        viewModel.toggleCellExpansion(at: 0)
        
        XCTAssertNotEqual(viewModel.expandedIndexSet, initialExpandedIndexSet, "Toggling cell expansion should modify the expandedIndexSet.")
        
        viewModel.toggleCellExpansion(at: 0)
        
        XCTAssertEqual(viewModel.expandedIndexSet, initialExpandedIndexSet, "Toggling cell expansion twice should revert the expandedIndexSet to its initial state.")
    }
    
    func testSortPostsByDate() {
        let post1 = PostListItem(postID: 1, timeshamp: 12345, title: "Post 1", previewText: "Text1", likesCount: 10)
        let post2 = PostListItem(postID: 2, timeshamp: 5678, title: "Post 2", previewText: "Text2", likesCount: 5)
        let post3 = PostListItem(postID: 3, timeshamp: 90123, title: "Post 3", previewText: "Text3", likesCount: 15)
        
        viewModel.posts = [post2, post1, post3]
        
        viewModel.sortPostsByDate()
        
        XCTAssertEqual(viewModel.posts, [post3, post1, post2], "Posts should be sorted by rating in descending order.")
    }
    
    func testSortPostsByRating() {
        let post1 = PostListItem(postID: 1, timeshamp: 12345, title: "Post 1", previewText: "Text1", likesCount: 10)
        let post2 = PostListItem(postID: 2, timeshamp: 5678, title: "Post 2", previewText: "Text2", likesCount: 5)
        let post3 = PostListItem(postID: 3, timeshamp: 90123, title: "Post 3", previewText: "Text3", likesCount: 15)
        
        viewModel.posts = [post2, post1, post3]
        
        viewModel.sortPostsByRating()
        
        XCTAssertEqual(viewModel.posts, [post3, post1, post2], "Posts should be sorted by rating in descending order.")
    }
}
