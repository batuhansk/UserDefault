import Foundation

extension UserDefaults {
    private static let testSuiteName = "com.batuhan.userdefaulttests"
    static let testSuite = UserDefaults(suiteName: testSuiteName)!

    static func cleanAllSuites() {
        for suite in [Self.standard, testSuite] {
            for (key, _) in suite.dictionaryRepresentation() {
                suite.removeObject(forKey: key)
            }
        }
    }
}
