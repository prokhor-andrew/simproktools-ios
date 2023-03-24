//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformerOutput<TriggerReason, CancelReason, Request: Equatable> {
    case willTrigger(id: String, reason: TriggerReason, isTriggerOnMain: Bool, request: Request)
    case willCancel(id: String, reason: CancelReason)
}
