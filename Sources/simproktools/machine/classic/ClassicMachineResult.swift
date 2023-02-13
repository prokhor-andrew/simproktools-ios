//
// Created by Andriy Prokhorenko on 13.02.2023.
//


public struct ClassicMachineResult<State, Output> {

    public let state: State
    public let outputs: [Output]

    public init(_ state: State, outputs: [Output]) {
        self.state = state
        self.outputs = outputs
    }

    public init(_ state: State, outputs: Output...) {
        self.init(state, outputs: outputs)
    }
}
