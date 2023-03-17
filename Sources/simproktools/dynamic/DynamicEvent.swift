//
//  DynamicEvent.swift
//  
//
//  Created by Andriy Prokhorenko on 23.02.2023.
//

public protocol DynamicEvent {
    associatedtype Id: Hashable
    associatedtype Data
    
    var id: Id { get }
    
    var data: Data { get }
    
    init(id: Id, data: Data)
}
