//
// Created by Andriy Prokhorenko on 18.02.2023.
//




public struct IdEvent<T>: DynamicEvent {

    public let id: String
    public let data: T

    public init(
            id: String,
            data: T
    ) {
        self.id = id
        self.data = data
    }
}
