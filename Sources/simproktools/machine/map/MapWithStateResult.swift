//
// Created by Andriy Prokhorenko on 13.02.2023.
//


public struct MapWithStateResult<State, Event> {

    public let state: State
    public let events: [Event]

    public init(_ state: State, events: [Event]) {
        self.state = state
        self.events = events
    }

    public init(_ state: State, events: Event...) {
        self.init(state, events: events)
    }
}