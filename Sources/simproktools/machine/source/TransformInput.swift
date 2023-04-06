//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformInput<LaunchReason, CancelReason, Response> {
    case didLaunchSucceed(String, LaunchReason)
    case didLaunchFail(String)
    case didCancelSucceed(String, CancelReason)
    case didCancelFail(String)
    case didEmit(String, Response)
}
