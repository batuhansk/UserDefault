import XCTest
@testable import UserDefault

final class UserDefaultTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UserDefault().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
