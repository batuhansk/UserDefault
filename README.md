# UserDefault

### UserDefault wrapper enables you to use `UserDefaults` in the simplest way with the power of `@propertyWrapper`.

Primitive types of Swift which conforms `Codable` protocol internally are supported. *(String, Int, Float, Double, Data, Bool, Date, URL)*

### Usage

```swift
struct Defaults {
    @UserDefault("is_discount_provided", defaultValue: false)
    static var isDiscountProvided: Bool
}
```

### How to Modify?

Well, that's pretty simple. You only have to access the variable through the `Defaults` struct, and set it the value.

```swift
Defaults.isDiscountProvided = true
```

In addition, Custom models which conforms `Codable` protocol can be stored too.

### Custom models

```swift
struct User: Codable {
    let firstName: String
    let lastName: String
}

struct Defaults {
     @UserDefault("default_user")
      static var defaultUser: User?
}
```

You can specify any `UserDefaults` suite for each one. If you want to store on standard suite, no needed to specify it. Default is `UserDefaults.standard`. 

### Usage of custom UserDefaults suite

```swift
struct Contact: Codable {
    let firstName: String
     let lastName: String
     let phoneNumber: String
}

private let appSuite = UserDefaults(suiteName: "com.strawb3rryx7.userdefault.appsuite")!
private let customSuite = UserDefaults(suiteName: "com.strawb3rryx7.userdefault.customsuite")!

struct Defaults {
     @UserDefault("primary_contact", suite: appSuite)
      static var primaryContact: Contact?
  
      @UserDefault("has_seen_purchase_screen", defaultValue: false, suite: customSuite)
      static var hasSeenPurchaseScreen: Bool
}
```

