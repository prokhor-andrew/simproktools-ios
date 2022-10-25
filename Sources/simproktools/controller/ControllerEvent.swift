//
//  ControllerEvent.swift
//  simproktools
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.



public enum ControllerEvent<Internal, External> {
    case int(Internal)
    case ext(External)
}
