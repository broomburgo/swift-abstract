// MARK: - Types

enum Ordering: CaseIterable {
  case lowerThan
  case equalTo
  case greaterThan

  static func merge(_ lhs: Self, _ rhs: Self) -> Self {
    switch lhs {
    case .lowerThan, .greaterThan:
      return lhs
    case .equalTo:
      return rhs
    }
  }
}

// MARK: - Protocols

protocol WithMinimum {
  static var minimum: Self { get }
}

protocol WithMaximum {
  static var maximum: Self { get }
}

extension Int8: WithMinimum {
  static let minimum = min
}

extension Int8: WithMaximum {
  static let maximum = max
}

extension Int16: WithMinimum {
  static let minimum = min
}

extension Int16: WithMaximum {
  static let maximum = max
}

extension Int32: WithMinimum {
  static let minimum = min
}

extension Int32: WithMaximum {
  static let maximum = max
}

extension Int64: WithMinimum {
  static let minimum = min
}

extension Int64: WithMaximum {
  static let maximum = max
}

extension Int: WithMinimum {
  static let minimum = min
}

extension Int: WithMaximum {
  static let maximum = max
}

extension UInt8: WithMinimum {
  static let minimum = min
}

extension UInt8: WithMaximum {
  static let maximum = max
}

extension UInt16: WithMinimum {
  static let minimum = min
}

extension UInt16: WithMaximum {
  static let maximum = max
}

extension UInt32: WithMinimum {
  static let minimum = min
}

extension UInt32: WithMaximum {
  static let maximum = max
}

extension UInt64: WithMinimum {
  static let minimum = min
}

extension UInt64: WithMaximum {
  static let maximum = max
}

extension UInt: WithMinimum {
  static let minimum = min
}

extension UInt: WithMaximum {
  static let maximum = max
}

extension Float: WithMinimum {
  static let minimum = -infinity
}

extension Float: WithMaximum {
  static let maximum = infinity
}

extension Double: WithMinimum {
  static let minimum = -infinity
}

extension Double: WithMaximum {
  static let maximum = infinity
}
