//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 25.02.2023.
//


public enum TransformInput<LaunchReason, CancelReason, Response> {
    case didLaunch(String, LaunchReason)
    case didCancel(String, CancelReason)
    case didEmit(String, Response)
    case didPause(String)
    case didResume(String)
    case didPauseAll
    case didResumeAll
}
