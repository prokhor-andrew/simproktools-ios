//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformerOutput<Request: Equatable> {
    case willTrigger(id: String, isTriggerOnMain: Bool, request: Request)
    case willCancel(id: String)
}
