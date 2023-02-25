//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformerOutput<Request: Equatable> {
    case willTrigger(String, Request)
    case willCancel(String)
}
