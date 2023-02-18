//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import Foundation

public struct IdEvent<T> {

    public let id: String
    public let event: T

    public init(
            id: String,
            event: T
    ) {
        self.id = id
        self.event = event
    }
}
