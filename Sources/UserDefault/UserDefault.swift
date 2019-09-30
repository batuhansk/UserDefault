//
//  UserDefault.swift
//
//  Copyright © 2019 Batuhan Saka. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
@propertyWrapper
public struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    public var wrappedValue: T {
        get {
            return get(key) ?? defaultValue
        } set {
            set(key, to: newValue)
        }
    }

    public func get<T: Codable>(_ key: String) -> T? {
        if UserDefaults.isPrimitiveType(T.self) {
            return userDefaults.object(forKey: key) as? T
        }

        if let value = userDefaults.string(forKey: key) {
            return userDefaults.decode(value)
        }

        return nil
    }

    public func set<T: Codable>(_ key: String, to data: T) {
        if UserDefaults.isPrimitiveType(T.self) {
            userDefaults.set(data, forKey: key)
            return
        }

        if let value = userDefaults.encode(data) {
            userDefaults.set(value, forKey: key)
        }
    }
}

extension UserDefault {
    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

extension UserDefault where T: ExpressibleByNilLiteral {
    public init(_ key: String, defaultValue: T = nil, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

extension UserDefaults {
    fileprivate static func isPrimitiveType<T: Codable>(_ type: T.Type) -> Bool {
        switch type {
        case is String.Type,
             is Data.Type,
             is Bool.Type,
             is Int.Type,
             is Float.Type,
             is URL.Type,
             is Date.Type,
             is Double.Type:
            return true
        default:
            return false
        }
    }

    fileprivate func encode<T: Codable>(_ value: T) -> String? {
        do {
            // Some codable values like URL and enum are encoded as a top-level
            // string which JSON can't handle, so we need to wrap it in an array
            // We need this: https://forums.swift.org/t/allowing-top-level-fragments-in-jsondecoder/11750
            let data = try JSONEncoder().encode([value])
            return String(String(data: data, encoding: .utf8)!.dropFirst().dropLast())
        } catch {
            print(error)
            return nil
        }
    }

    fileprivate func decode<T: Codable>(_ value: String) -> T? {
        guard let data = "[\(value)]".data(using: .utf8) else {
            return nil
        }

        do {
            return (try JSONDecoder().decode([T].self, from: data)).first
        } catch {
            return nil
        }
    }
}
