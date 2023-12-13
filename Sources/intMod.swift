//
//  intMod.swift
//  AKS
//
//  Created by Rex Fang on 2023-12-11.
//

/*
 This file contains the implementation of an integer quotient ring.
 */

import Foundation

extension Array where Element == Z {
    
    /// Add a c-multiple of arr onto the current array.
    mutating func addMultiple(of arr: [Z], scalar c: Z) {
        guard arr.count <= self.count else { return }
        for i in 0..<arr.count {
            self[i] += c * arr[i]
        }
    }
    
}

/// Integers with a modulus.
struct Z: Equatable, CustomStringConvertible {
    
    // [MARK] Core Properties and Methods
    
    /// Current modulus.
    static var modulus: Int = 7
    
    /// Set static modulus to n.
    static func setMod(to n: Int) {
        assert (n > 0)
        Self.modulus = n
    }
    
    /// An integer representation of element in ring.
    var repr: Int
    
    /// Creates a ring element.
    init (_ n: Int) {
        self.repr = n % Self.modulus
    }
    
    // [MARK] Special Elements
    
    /// Additive identity.
    static func addId() -> Self { Z(0) }
    
    /// Multiplicative identity.
    static func multId() -> Self { Z(1) }
    
    // [MARK] Conform to CustomStringConvertible
    
    /// An integer representation of the element.
    var description: String {
        return "\(self.repr)"
    }
    
    /// An integer representation of the element along with current modulus.
    var moddedDescription: String {
        return "\(self.repr) (mod \(Self.modulus))"
    }
    
    /// An integer representation of the element, but empty if element is zero.
    var descriptionWithoutZero: String {
        (self == Self.addId()) ? "" : self.description
    }
    
    // [MARK] Binary Operations & Conform to Equatable
    
    /// Equivalence relation.
    static func == (lhs: Z, rhs: Z) -> Bool {
        return (lhs.repr - rhs.repr) % Self.modulus == 0
    }
    
    /// Non-equivalence relation.
    static func != (lhs: Z, rhs: Z) -> Bool {
        return !(lhs == rhs)
    }
    
    /// Addition.
    static func + (lhs: Z, rhs: Z) -> Self {
        Self.init(lhs.repr + rhs.repr)
    }
    
    /// Addition assignment.
    static func += (lhs: inout Z, rhs: Z) {
        lhs = lhs + rhs
    }
    
    /// Subtraction.
    static func - (lhs: Z, rhs: Z) -> Self {
        Self.init(lhs.repr - rhs.repr)
    }
    
    /// Subtraction assignment.
    static func -= (lhs: inout Z, rhs: Z) {
        lhs.repr = lhs.repr - rhs.repr
    }
    
    /// Multiplication using current modulus.
    static func * (lhs: Z, rhs: Z) -> Self {
        return Self.init(lhs.repr * rhs.repr)
    }
    
    /// Multiplication assignment.
    static func *= (lhs: inout Z, rhs: Z) {
        lhs = lhs * rhs
    }

    // [MARK] Derived Operations
    
    /// The additive inverse of the current element.
    var negated: Z {
        return Z(-self.repr)
    }
    
    /// Current element squared.
    var squared: Self {
        return self * self
    }
    
    /// Exponentiation with integer exponent.
    func toThe(exponent e: Int) -> Self {
        if e < 1 {
            return Self.multId()
        } else {
            var exponent = e
            var currentBase = self
            var result = Self.multId()
            while exponent != 0 {
                if exponent % 2 == 1 {
                    result *= currentBase
                }
                currentBase = currentBase.squared
                exponent /= 2
            }
            return result
        }
    }
    
    /// Computes order of element in current ring.
    var order: Int {
        guard self != Self.addId() else { return 0 }
        var e = 1
        var current = self
        let multId = Self.multId()
        while current != multId && e <= Self.modulus {
            current *= self
            e += 1
        }
        return e
    }
    
}
