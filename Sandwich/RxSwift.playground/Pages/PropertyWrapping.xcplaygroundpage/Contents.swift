//: [Previous](@previous)
// Started from examples here: https://www.swiftbysundell.com/articles/published-properties-in-swift/

import UIKit
import RxCocoa
import RxSwift
import RxRelay

/// To persist updates through either the `wrappedValue` or `relay` while keeping the implementing property a value type.
private var cache = NSCache<AnyObject, AnyObject>()

@propertyWrapper
struct Bindable<Element> {
    var projectedValue: Bindable { self }
    var wrappedValue: Element {
        get {
            cache.object(forKey: id) as? Element
                ?? historicalValue
        }
        set {
            cache.removeObject(forKey: id)
            historicalValue = newValue
            relay.accept(newValue)
        }
    }
    /// Used to cache the wrappedValue when it is updated by the relay
    private let id: AnyObject
    /// Used to store the wrappedValue when it is directly updated
    private var historicalValue: Element
    let relay: BehaviorRelay<Element>

    init(wrappedValue: Element) {
        self.id = UUID() as AnyObject
        self.historicalValue = wrappedValue
        self.relay = .init(value: wrappedValue)
    }
}

extension Bindable: ObservableType, ObserverType {
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable where
        Observer: ObserverType, Element == Observer.Element {
        relay.asObservable().subscribe(observer)
    }
    
    func on(_ event: Event<Element>) {
        if case .next(let newValue) = event {
            cache.setObject(newValue as AnyObject, forKey: id)
            relay.accept(newValue)
        }
    }
}

extension Bindable {
    
    func twoWayBind(to property: ControlProperty<Element>) -> Disposable {
        return Disposables.create(
            relay.bind(to: property),
            property.bind(to: relay)
        )
    }
    
    func twoWayBind(to property: ControlProperty<Element>, disposeBag: DisposeBag) {
        disposeBag.insert {
            relay.bind(to: property)
            property.bind(to: relay)
        }
    }
}

/// A super simple domain object
struct User {
    @Bindable var name: String
    
    init(name: String) {
        self.name = name
    }
}

/// Allows access to its domain model
struct DirectViewModel {
    var user: User
}

/// Restricts direct access to its domain model, exposing the Bindable property through a computed property
struct IndirectViewModel {
    var name: Bindable<String> { user.$name }
    private let user: User
}

func compare<T: Equatable>(_ lhs: T, _ rhs: T) -> Bool {
    let isEqual = lhs == rhs
    print("\(lhs) and \(rhs) \(isEqual ? "ARE" : "ARE NOT") the same.")
    return isEqual
}

let oldUser = User(name: "Sonny")
var vm = DirectViewModel(user: oldUser)

// Make sure the property wrapper doesn't create a reference type

vm.user.name = "Sport"

print("Old vs New name\n________________")
print(compare(oldUser.name, vm.user.name) ? "❌" : "✅")
print("\n")

// Make sure the wrapped value updates appropriately

let newName: BehaviorRelay<String> = .init(value: vm.user.name)
_ = newName.bind(to: vm.user.$name)
newName.accept("Champ")

sleep(1)

print("Relay vs Wrapped Value\n_____________________")
print(compare(vm.user.$name.relay.value, vm.user.name) ? "✅" : "❌")
print("\n")

vm.user.name = "Kiddo"
sleep(1)

print("Relay vs Wrapped Value\n_____________________")
print(compare(vm.user.$name.relay.value, vm.user.name) ? "✅" : "❌")
print("\n")

print("Old vs New name\n________________")
print(compare(oldUser.name, vm.user.name) ? "❌" : "✅")
print("\n")
//: [Next](@next)
