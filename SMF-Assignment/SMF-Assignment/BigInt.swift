//
//  BigInt.swift
//  SMF-Assignment
//
//  Created by Waqas Sultan on 9/22/19.
//  Copyright © 2019 Waqas Sultan. All rights reserved.
//

import Foundation

struct BigInt {
    
    var value: String
    
    
    func add(right: BigInt) -> BigInt {
        var leftCharacterArray = value.reversed().map { Int(String($0))! }
        var rightCharacterArray = right.value.reversed().map { Int(String($0))! }
        var result = [Int](repeating: 0, count: leftCharacterArray.count+rightCharacterArray.count)
        
        let maxLengith = max(leftCharacterArray.count,rightCharacterArray.count)
        //  for leftIndex in 0..<leftCharacterArray.count {
        for rightIndex in 0..<maxLengith {
            
            let resultIndex =  rightIndex
            // i have changes this belwo add  sign..............this one
            result[resultIndex] = (leftCharacterArray.count > resultIndex ? leftCharacterArray[rightIndex]  : 0)  + (rightCharacterArray.count > resultIndex ? rightCharacterArray[rightIndex]  : 0) + (resultIndex >= result.count ? 0 : result[resultIndex])
            if result[resultIndex] > 9 {
                result[resultIndex + 1] = (result[resultIndex] / 10) + (resultIndex+1 >= result.count ? 0 : result[resultIndex + 1])
                result[resultIndex] -= (result[resultIndex] / 10) * 10
            } else {
                // break
            }
            
        }
        
        //  }
        
        result = Array(result.reversed())
        var nonZeroValue = false
        result = result.filter({ (value) -> Bool in
            if value != 0 {
                nonZeroValue = true
                return true
            } else if value == 0 && nonZeroValue == false {
                return false
            }
            return true
            
        })
        return  BigInt(value: result.map { String($0) }.joined(separator: ""))
    }
    
    
    
    func compareTwoBigInt(right:BigInt) -> Bool {
        var leftCharacterArray = value.map { Int(String($0))! }
        var rightCharacterArray = right.value.map { Int(String($0))! }
        
        
        if leftCharacterArray.count != leftCharacterArray.count {
            return false
        } else {
            let maxLengith = max(leftCharacterArray.count,rightCharacterArray.count)
            //  for leftIndex in 0..<leftCharacterArray.count {
            for rightIndex in 0..<maxLengith {
                
                let resultIndex =  rightIndex
                // i have changes this belwo add  sign..............this one
                if ((leftCharacterArray.count > resultIndex ? leftCharacterArray[rightIndex]  : 0)  !=  (rightCharacterArray.count > resultIndex ?rightCharacterArray[rightIndex]  : 0)  ) {
                    return false
                }
                
                
            }
        }
        
        
        return true
    }
    
    func multiply(right: BigInt) -> BigInt {
        var leftCharacterArray = value.reversed().map { Int(String($0))! }
        var rightCharacterArray = right.value.reversed().map { Int(String($0))! }
        var result = [Int](repeating: 0, count: leftCharacterArray.count+rightCharacterArray.count)
        
        for leftIndex in 0..<leftCharacterArray.count {
            for rightIndex in 0..<rightCharacterArray.count {
                
                let resultIndex = leftIndex + rightIndex
                
                result[resultIndex] = leftCharacterArray[leftIndex] * rightCharacterArray[rightIndex] + (resultIndex >= result.count ? 0 : result[resultIndex])
                if result[resultIndex] > 9 {
                    result[resultIndex + 1] = (result[resultIndex] / 10) + (resultIndex+1 >= result.count ? 0 : result[resultIndex + 1])
                    result[resultIndex] -= (result[resultIndex] / 10) * 10
                }
                
            }
            
        }
        
        result = Array(result.reversed())
        
        while result.count > 0 && result.first == 0 {
            result.removeFirst(1)
        }
        
        return  BigInt(value: result.map { String($0) }.joined(separator: ""))
    }
    
}
