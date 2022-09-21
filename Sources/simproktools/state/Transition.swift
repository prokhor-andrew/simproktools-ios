//
//  Transition.swift
//  simprokcore
//
//  Created by Andrey Prokhorenko on 01.12.2021.
//  Copyright (c) 2022 simprok. All rights reserved.


public enum Transition<S> {
    case set(S)
    case skip
}
