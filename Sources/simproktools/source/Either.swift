//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 24.03.2023.
//

import Foundation


public enum Either<First, Second> {
    case first(First)
    case second(Second)
    
    
    public var first: First? {
        switch self {
        case .first(let value):
            return value
        case .second:
            return nil
        }
    }
    
    public var second: Second? {
        switch self {
        case .first:
            return nil
        case .second(let value):
            return value
        }
    }
    
    public var isFirst: Bool {
        first != nil
    }
    
    public var isSecond: Bool {
        second != nil
    }
}
