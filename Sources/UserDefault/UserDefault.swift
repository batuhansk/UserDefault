import Foundation

@propertyWrapper
public struct UserDefault<T: Codable> {
    // MARK: - Properties
    private let key: String
    private let defaultValue: T
    private let defaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public var wrappedValue: T {
        get {
            getValue(for: key) ?? defaultValue
        } set {
            setValue(for: key, data: newValue)
        }
    }

    ///  Returns the object from the relevant suite with the given key.
    ///
    /// - Parameter key: Key of the data.
    /// - Returns: An object which gathered from the relevant suite.
    private func getValue<T: Codable>(for key: String) -> T? {
        guard let value = defaults.string(forKey: key) else { return nil }
        return defaults.decode(value, decoder: decoder)
    }

    ///  Sets data to the relevant suite with the given key.
    ///
    /// - Parameter key: Key of the data.
    /// - Parameter data: A data that should be set to `UserDefaults`.
    private func setValue<T: Codable>(for key: String, data: T) {
        guard let value = defaults.encode(data, encoder: encoder) else { return }
        defaults.set(value, forKey: key)
    }
}

public extension UserDefault where T: ExpressibleByNilLiteral {
    /// Creates `UserDefault` with given key, defaultValue and userDefaults.
    ///
    /// - Parameter key: Key of the data.
    /// - Parameter defaultValue: Default value.
    /// - Parameter defaults: UserDefaults instance.
    /// - Parameter encoder: JSONEncoder instance.
    /// - Parameter decoder: JSONDecoder instance.
    init(_ key: String,
         defaultValue: T = nil,
         defaults: UserDefaults = .standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
        self.encoder = encoder
        self.decoder = decoder
    }
}

public extension UserDefault {
    /// Creates `UserDefault` with given key, defaultValue and userDefaults.
    ///
    /// - Parameter key: Key of the data.
    /// - Parameter defaultValue: Default value.
    /// - Parameter defaults: UserDefaults instance.
    /// - Parameter encoder: JSONEncoder instance.
    /// - Parameter decoder: JSONDecoder instance.
    init(_ key: String,
         defaultValue: T,
         defaults: UserDefaults = .standard,
         encoder: JSONEncoder = JSONEncoder(),
         decoder: JSONDecoder = JSONDecoder()) {
        self.key = key
        self.defaultValue = defaultValue
        self.defaults = defaults
        self.encoder = encoder
        self.decoder = decoder
    }
}

// MARK: - UserDefaults helpers
private extension UserDefaults {
    func encode<T: Codable>(_ value: T, encoder: JSONEncoder) -> String? {
        do {
            let data = try encoder.encode(value)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    func decode<T: Codable>(_ value: String, decoder: JSONDecoder) -> T? {
        guard let data = value.data(using: .utf8) else {
            return nil
        }
        return try? decoder.decode(T.self, from: data)
    }
}
