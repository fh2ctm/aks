//
//  Numbers.swift
//  AKS
//
//  Created by Rex Fang on 2023-12-11.
//

/*
 This file contains number theory functions.
 */

import Foundation
import Numerics

/// Compute the positive greatest commmon divisor using Euclidean algorithm.
func gcd(_ a: UInt, _ b: UInt) -> UInt {
  var y = b
  var x = a
  var t: UInt = 0
  while y != 0 {
    t = y
    y = x % y
    x = t
  }
  return x
}

/// Check whether two numbers are coprime.
func areCoprime(_ a: UInt, _ b: UInt) -> Bool {
  return gcd(a, b) == 1
}

extension UInt {
  
  /// Check whether the number is coprime to c.
  func isCoprime(to c: UInt) -> Bool {
    return areCoprime(self, c)
  }
  
  /// Check whether the number is a perfect power of another number.
  var isPerfectPower: Bool {
    if self < 4 { return false }
    for p in 2...Int(ceil(log2(Double(self)))) {
      let pthRoot = pow(Double(self), 1/Double(p))
      if pthRoot == floor(pthRoot) {
        return true
      }
    }
    return false
  }
  
}

/// Euler's Phi function
func eulerPhi(_ n: UInt) -> UInt {
  guard n > 0 else { return 0 }
  var foundCoprimes: UInt = 0
  for i in 1...n {
    if n.isCoprime(to: i) { foundCoprimes += 1 }
  }
  return foundCoprimes
}
