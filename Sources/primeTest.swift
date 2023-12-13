//
//  primeTest.swift
//  AKS
//
//  Created by Rex Fang on 2023-12-12.
//

/*
 This file contains the implementation of AKS Primality Test.
 */

import Foundation
import ArgumentParser

/// Use AKS to determine if the given integer is prime.
private func testPrime(_ n: Int) -> Bool {
    
    // Check smaller numbers.
    guard n > 1 else { return false }
    
    // Check if n is a perfect power.
    if n.isPerfectPower { return false }
    if DEBUG { print("\(n) is not a perfect power. ") }
    
    // Find order r.
    var r = 2
    Z.setMod(to: r)
    var nRep = Z(n)
    while nRep.order <= Int(pow(log2(Double(n)), 2.0)) {
        r += 1
        Z.setMod(to: r)
        nRep = Z(n)
    }
    if DEBUG { print("Found r=\(r). ") }
    
    // Check GCD of numbers less than r with n.
    for a in 2...r {
        if (2..<n).contains(gcd(a,n)) { return false }
    }
    if DEBUG { print("All numbers less than r=\(r) are coprime to n=\(n). ") }
    
    // Check if n greater than r.
    if n <= r { return true }
    if DEBUG { print("n=\(n) is greater than r=\(r). ") }
    
    // Polynomial comparisons.
    Z.setMod(to: n)
    Poly.setExpMod(to: r)
    let upperBound = Int(floor(sqrt(Double(eulerPhi(r))) * log2(Double(n))))
    if DEBUG { print("Checking a up to \(upperBound)...") }
    for a in 1...upperBound {
        let lhs = Poly([0:Z(a), 1:Z.multId()]).toThe(exponent: n)   // (a + x)^n
        let rhs = Poly([0:Z(a)]) + Poly([(n % r):Z.multId()])       // a + x^n
        if lhs != rhs { return false }
        if DEBUG { print("Passed a=\(a). ") }
    }
    
    return true
    
}

extension Int {
    
    /// Check whether current number is prime using AKS.
    var isPrime: Bool { return testPrime(self) }
    
}

/// Test if n is prime and print results.
func testOnePrime(_ n: Int) {
    if n.isPrime {
        print("[INFO] \(n) is prime. ")
    } else {
        print("[INFO] \(n) is composite. ")
    }
}

/// Find primes within a range and print results.
func findPrimes(between a: Int, and b: Int) {
    assert (a < b)
    print("Looking for primes between \(a) and \(b): ")
    var primeCounter = 0
    for n in a...b where n.isPrime {
        if !DEBUG { print("\(n)", terminator: " ") }
        primeCounter += 1
    }
    print("\nDone. Found \(primeCounter) primes between \(a) and \(b). ")
}

/// DEBUG Option, prints out AKS computation steps if true.
var DEBUG = false

/// A Command Line Interface Implementation.
@main struct AKS: ParsableCommand {
    
    @Argument(help: "The number that you want to test, or the lower bound of a range you want to find primes in. ")
    var a: Int
    
    @Argument(help: "The upper bound of a range you want to find primes in. ")
    var b: Int?
    
    @Flag(help: "If enabled, prints out logs from AKS computation. ")
    var verbose: Bool = false
    
    mutating func run() {
        if verbose { DEBUG = true }
        if let ub = b {
            let lb = a
            guard lb > 0 && lb < ub else {
                print("[ERROR] Invalid bounds (\(lb),\(ub)). Please make sure you entered positive numbers in increasing order. ")
                return
            }
            findPrimes(between: lb, and: ub)
        } else {
            guard a > 0 else {
                print("[ERROR] Invalid number \(a). Please enter a positive number. ")
                return
            }
            testOnePrime(a)
        }
    }
    
}
