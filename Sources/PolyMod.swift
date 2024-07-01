//
//  polyMod.swift
//  AKS
//
//  Created by Rex Fang on 2023-12-11.
//

/*
 This file contains the implementation of a polynomial ring over an integer quotient ring.
 */

import Foundation

/// Polynomials over the ring R (defined in IntMod).
struct Poly: CustomStringConvertible {
  
  // MARK: - Core Properties and Methods
  
  /// Current exponent modulus.
  static var exponentModulus: Int = 30
  
  /// Set the static exponent modulus.
  static func setExpMod(to r: Int) {
    assert (r > 0)
    Self.exponentModulus = r
  }
  
  /// Coefficients indexed by exponents.
  var coeffs: [R]
  
  /// Initialization from a coefficient dictionary.
  init (_ coeffDict: [Int:R]) {
    self.coeffs = Array.init(repeating: R.addId(), count: Self.exponentModulus)
    for key in coeffDict.keys {
      self.coeffs[key] = coeffDict[key]!
    }
  }
  
  /// Initialization from a coefficient array.
  init (_ coeffs: [R]) {
    assert (coeffs.count == Self.exponentModulus)
    self.coeffs = coeffs
  }
  
  // MARK: - Special Elements
  
  /// Additive identity.
  static func addId() -> Self { return Poly([:]) }
  
  /// Multiplicative identity.
  static func multId() -> Self { return Poly([0:R.multId()]) }
  
  // MARK: - For Conveniences
  
  /// Range of exponents for easier iterations.
  static var expRange: Range<Int> { return (0..<Self.exponentModulus) }
  
  /// Access coefficients.
  subscript (_ n: Int) -> R {
    get {
      return self.coeffs[n]
    } set {
      self.coeffs[n] = newValue
    }
  }
  
  /// Returns empty array of size current modulusw.
  private static var sizedEmptyArray: [R] {
    return Array.init(repeating: R.addId(), count: Self.exponentModulus)
  }
  
  // MARK: - Conform to CustomStringConvertible
  
  /// String description.
  var description: String {
    var outStr = ""
    for i in Self.expRange {
      guard self[i] != R.addId() else { continue }
      outStr += "\(self[i])(\(i)), "
    }
    return outStr
  }
  
  // MARK: - Binary Operations
  
  /// Equivalence relation.
  static func == (lhs: Poly, rhs: Poly) -> Bool {
    return lhs.coeffs == rhs.coeffs
  }
  
  /// Non-equivalence relation.
  static func != (lhs: Poly, rhs: Poly) -> Bool {
    return !(lhs == rhs)
  }
  
  /// Addition.
  static func + (lhs: Poly, rhs: Poly) -> Self {
    var newPoly = lhs
    for rt in Self.expRange {
      newPoly[rt] += rhs[rt]
    }
    return newPoly
  }
  
  /// Subtraction.
  static func - (lhs: Poly, rhs: Poly) -> Self {
    var newPoly = lhs
    for rt in Self.expRange {
      newPoly[rt] -= rhs[rt]
    }
    return newPoly
  }
  
  /// Multiplication.
  static func * (lhs: Poly, rhs: Poly) -> Self {
    var newPoly = Poly.addId()
    for lt in Self.expRange {
      for rt in Self.expRange {
        let targetExp = (lt + rt) % Self.exponentModulus
        newPoly[targetExp] += lhs[lt] * rhs[rt]
      }
    }
    return newPoly
  }
  
  /// Multiplication assignment.
  static func *= (lhs: inout Poly, rhs: Poly) {
    lhs = lhs * rhs
  }
  
  // MARK: - Derived Operations
  
  /// Additive Inverse of the current polynomial.
  var negated: Poly {
    return self.scale(by: R.multId().negated)
  }
  
  /// Scalar multiplication.
  func scale(by n: R) -> Poly {
    var newPoly = self
    for degree in 0..<Self.exponentModulus {
      newPoly[degree] *= n
    }
    return newPoly
  }
  
  /// Polynomial squared.
  var squared: Poly {
    var new: [R] = Self.sizedEmptyArray
    for i in Self.expRange {
      new.addMultiple(of: self.coeffs, scalar: self[i])
      new.shiftLeft()
    }
    return Poly(new)
  }
  
  /// Exponentiation with integer exponent.
  func toThe(exponent e: Int) -> Self {
    if e <= 1 {
      return Self.multId()
    } else {
      var exponent = e
      var currentBase = self
      var result = Self.multId()
      while exponent != 0 {
        if exponent % 2 == 1 {
          result *= currentBase
          exponent -= 1
        }
        currentBase = currentBase.squared
        exponent /= 2
      }
      return result
    }
  }
  
}
