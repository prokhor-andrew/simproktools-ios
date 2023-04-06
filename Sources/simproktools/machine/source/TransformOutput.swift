//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformOutput<LaunchReason, CancelReason, Request: Equatable> {
    case willLaunch(id: String, reason: LaunchReason, isLaunchOnMain: Bool, request: Request)
    case willCancel(id: String, reason: CancelReason)
}
