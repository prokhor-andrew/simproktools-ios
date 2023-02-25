//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformerInput<Response> {
    case didTrigger(String)
    case didCancel(String)
    case didEmit(String, Response)
}
