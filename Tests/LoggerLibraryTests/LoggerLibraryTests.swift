import XCTest
@testable import LoggerLibrary

final class LoggerLibraryTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LoggerLibrary().text, "Hello, World!")
    }
}
