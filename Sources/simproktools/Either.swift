//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.12.2023.
//


public enum Either<L, R> {
    case left(L)
    case right(R)

    public var isLeft: Bool {
        switch self {
        case .left: true
        case .right: false
        }
    }
    
    public var isRight: Bool { !isLeft }
}
