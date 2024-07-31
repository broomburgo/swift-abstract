// MARK: - Types

public enum Ordering: CaseIterable {
  case lowerThan
  case equalTo
  case greaterThan

  public static func merge(_ lhs: Self, _ rhs: Self) -> Self {
    switch lhs {
    case .lowerThan, .greaterThan:
      return lhs
    case .equalTo:
      return rhs
    }
  }
}

// MARK: - Protocols

public protocol WithMinimum {
  static var minimum: Self { get }
}

public protocol WithMaximum {
  static var maximum: Self { get }
}

extension Int8: WithMinimum {
  public static let minimum = min
}

extension Int8: WithMaximum {
  public static let maximum = max
}

extension Int16: WithMinimum {
  public static let minimum = min
}

extension Int16: WithMaximum {
  public static let maximum = max
}

extension Int32: WithMinimum {
  public static let minimum = min
}

extension Int32: WithMaximum {
  public static let maximum = max
}

extension Int64: WithMinimum {
  public static let minimum = min
}

extension Int64: WithMaximum {
  public static let maximum = max
}

extension Int: WithMinimum {
  public static let minimum = min
}

extension Int: WithMaximum {
  public static let maximum = max
}

extension UInt8: WithMinimum {
  public static let minimum = min
}

extension UInt8: WithMaximum {
  public static let maximum = max
}

extension UInt16: WithMinimum {
  public static let minimum = min
}

extension UInt16: WithMaximum {
  public static let maximum = max
}

extension UInt32: WithMinimum {
  public static let minimum = min
}

extension UInt32: WithMaximum {
  public static let maximum = max
}

extension UInt64: WithMinimum {
  public static let minimum = min
}

extension UInt64: WithMaximum {
  public static let maximum = max
}

extension UInt: WithMinimum {
  public static let minimum = min
}

extension UInt: WithMaximum {
  public static let maximum = max
}

extension Float: WithMinimum {
  public static let minimum = -infinity
}

extension Float: WithMaximum {
  public static let maximum = infinity
}

extension Double: WithMinimum {
  public static let minimum = -infinity
}

extension Double: WithMaximum {
  public static let maximum = infinity
}
