@testable import Reading_List

import Combine
import XCTest

final class ReadingListLoaderTests: XCTestCase {
    
    // Unit under test
    var readingListLoader: ReadingListLoader!
    
    // Dependencies
    var dataLoaderFake: DataLoaderFake!
    var userFake: UserFake!
    var cacheFake: CacheFake!
    
    var cancellable: AnyCancellable?

    override func setUp() {
        super.setUp()
        dataLoaderFake = DataLoaderFake()
        userFake = UserFake()
        cacheFake = CacheFake()
        readingListLoader = ReadingListLoader(dataLoader: dataLoaderFake, user: userFake, cache: cacheFake)
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable?.cancel()
    }

    func testLoadingReadingList() throws {
        // Given the data loader has some data
        dataLoaderFake.data = try Helpers.responseData()
        
        // and the user has a username
        userFake.username = "xXxG4M3r360xXx"
        
        // When we load the reading list
        let expectation = expectation(description: "Loading reading list")
        var expectedReadingLog: ReadingLog?
        cancellable = readingListLoader.loadingPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { readingLog in
                expectedReadingLog = readingLog
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a reading log with some entries
        XCTAssertGreaterThan(expectedReadingLog?.readingLogEntries.count ?? 0, 0)
    }
    
    func testLoadingReadingListWithDecodingError() throws {
        // Given the data loader has some bogus data
        dataLoaderFake.data = "this is not the reading list you are looking for".data(using: .utf8)
        
        // and the user has a username
        userFake.username = "xXxG4M3r360xXx"
        
        // When we load the reading list
        let expectation = expectation(description: "Loading reading list")
        var expectedError: Error?
        cancellable = readingListLoader.loadingPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("We were not expecting a valid object")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get an error
        XCTAssertNotNil(expectedError as? DecodingError)
    }
    
    func testLoadingReadingListWithNoUsername() throws {
        // Given the data loader has some data
        dataLoaderFake.data = try Helpers.responseData()
        
        // When we load the reading list
        let expectation = expectation(description: "Loading readling list")
        var expectedError: Error?
        cancellable = readingListLoader.loadingPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("We were not expecting a valid object")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get an error
        XCTAssertEqual(expectedError as? ReadingListLoaderError, .invalidURL)
    }

}
