@testable import Reading_List

import Combine
import Foundation
import XCTest

import PageLoader

final class ReadingListViewModelTests: XCTestCase {
    
    // Unit under test
    var viewModel: ReadingListViewModel!
    
    // Dependencies
    var readingListLoaderFake: ReadingListLoaderFake!
    var imageLoaderFake: ImageLoaderFake!
    
    var cancellable: AnyCancellable?
    
    override func setUp() {
        super.setUp()
        
        readingListLoaderFake = ReadingListLoaderFake()
        imageLoaderFake = ImageLoaderFake()
        viewModel = ReadingListViewModel(readingListLoader: readingListLoaderFake, imageLoader: imageLoaderFake)
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable?.cancel()
    }
    
    func testLoadItems() throws {
        // Given the loader will return a reading log
        readingListLoaderFake.readingLog = try Helpers.responseReadingLog()
        
        // and that we subscribe to the itemsPublisher
        let expectation = expectation(description: "Loading items")
        var expectedItems: [ReadingListItemViewModel]?
        cancellable = viewModel.itemsPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { items in
                expectedItems = items
                expectation.fulfill()
            })
        
        // When we load the items
        viewModel.loadItems()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get some items
        XCTAssertGreaterThan(expectedItems?.count ?? 0, 0)
    }
    
    func testLoadItemsSetsTheStateToLoaded() throws {
        // Given the loader will return a reading log
        readingListLoaderFake.readingLog = try Helpers.responseReadingLog()
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the items
        viewModel.loadItems()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .loaded)
    }
    
    func testLoadItemsSetsTheStateToError() throws {
        // Given the loader will produce an error
        readingListLoaderFake.error = TestError.generic
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the items
        viewModel.loadItems()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .error)
    }
}
