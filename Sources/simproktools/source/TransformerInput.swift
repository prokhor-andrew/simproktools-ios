//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformerInput<TriggerReason, CancelReason, Response> {
    case didTrigger(String, TriggerReason)
    case didCancel(String, CancelReason)
    case didEmit(String, Response)
}
