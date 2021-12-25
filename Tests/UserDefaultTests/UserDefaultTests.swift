import XCTest
@testable import UserDefault

final class UserDefaultTests: XCTestCase {
    private struct Employee: Codable {
        let fullName: String
        let age: Int
    }

    private enum EmployeeType: String, Codable {
        case fullTime
        case partTime
        case contractor
    }

    private struct StandardValueContainer {
        @UserDefault("appLaunchCount", defaultValue: 3)
        static var appLaunchCount: Int

        @UserDefault("onboardingDesc")
        static var onboardingDesc: String?

        @UserDefault("onboardingSeen", defaultValue: false)
        static var onboardingSeen: Bool

        @UserDefault("lastOrderAmount", defaultValue: 0.0)
        static var lastOrderAmount: Double

        @UserDefault("supportURL", defaultValue: URL(string: "https://developer.apple.com")!)
        static var supportURL: URL
    }

    private struct SpecializedValueContainer {
        @UserDefault("employee", defaults: .testSuite)
        static var employee: Employee?

        @UserDefault("employeeType", defaultValue: .partTime, defaults: .testSuite)
        static var employeeType: EmployeeType
    }

    override func setUp() {
        super.setUp()
        UserDefaults.cleanAllSuites()
    }

    func test_GetAndSet_OptStringValueWithStandardSuite() {
        XCTAssertNil(StandardValueContainer.onboardingDesc)

        StandardValueContainer.onboardingDesc = "Greetings, John"

        XCTAssertEqual(StandardValueContainer.onboardingDesc, "Greetings, John")
    }

    func test_GetAndSet_BoolValueWithStandardSuite() {
        XCTAssertFalse(StandardValueContainer.onboardingSeen)

        StandardValueContainer.onboardingSeen = true

        XCTAssertTrue(StandardValueContainer.onboardingSeen)
    }

    func test_GetAndSet_IntegerValueWithStandardSuite() {
        XCTAssertEqual(StandardValueContainer.appLaunchCount, 3)

        StandardValueContainer.appLaunchCount = 5

        XCTAssertEqual(StandardValueContainer.appLaunchCount, 5)
    }

    func test_GetAndSet_DoubleValueWithStandardSuite() {
        XCTAssertEqual(StandardValueContainer.lastOrderAmount, 0.0)

        StandardValueContainer.lastOrderAmount = 149.99

        XCTAssertEqual(StandardValueContainer.lastOrderAmount, 149.99)
    }

    func test_GetAndSet_URLValueWithStandardSuite() {
        XCTAssertEqual(StandardValueContainer.supportURL.absoluteString, "https://developer.apple.com")

        StandardValueContainer.supportURL = URL(string: "https://apple.com/support")!

        XCTAssertEqual(StandardValueContainer.supportURL.absoluteString, "https://apple.com/support")
    }

    func test_GetAndSet_CustomTypeWithSpecializedSuite() {
        XCTAssertNil(SpecializedValueContainer.employee)

        SpecializedValueContainer.employee = Employee(fullName: "John Doe", age: 30)

        XCTAssertEqual(SpecializedValueContainer.employee?.fullName, "John Doe")
        XCTAssertEqual(SpecializedValueContainer.employee?.age, 30)
    }

    func test_GetAndSet_EnumTypeWithSpecializedSuite() {
        XCTAssertEqual(SpecializedValueContainer.employeeType, .partTime)

        SpecializedValueContainer.employeeType = .fullTime

        XCTAssertEqual(SpecializedValueContainer.employeeType, .fullTime)

        SpecializedValueContainer.employeeType = .contractor

        XCTAssertEqual(SpecializedValueContainer.employeeType, .contractor)
    }
}
