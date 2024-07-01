//
//  ArrayExt.swift
//  AKS
//
//  Created by Rex Fang on 2023-12-11.
//

/*
 This file contains helpful new array methods.
 */

import Foundation

public extension Array {
  
  /// Shift array to the left by one element.
  var shiftedLeft: Self {
    var new = self
    new.append(new.removeFirst())
    return new
  }
  
  /// Shift array to the right by one element.
  var shiftedRight: Self {
    var new = self
    new.insert(new.removeLast(), at: 0)
    return new
  }
  
  /// Shift array to the left by one element in-place.
  mutating func shiftLeft() {
    self = self.shiftedLeft
  }
  
  /// Shift array to the right by one element in-place.
  mutating func shiftRight() {
    self = self.shiftedRight
  }
  
}


