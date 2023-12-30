////
//// Created by Andriy Prokhorenko on 13.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//
//public extension Machine {
//
//    func mapOutput<ROutput>(_ function: @escaping (Output, String, MachineLogger) -> [ROutput]) -> Machine<Input, ROutput> {
//        mapOutput(with: Void()) { state, output, id, logger in
//            (state, function(output, id, logger))
//        }
//    }
//
//    func mapOutput<State, ROutput>(
//        with state: @escaping @autoclosure () -> State,
//        function: @escaping (State, Output, String, MachineLogger) -> (newState: State, outputs: [ROutput])
//    ) -> Machine<Input, ROutput> {
//        biMap(with: state, mapInput: { state, input, id, logger in (state, [input]) }, mapOutput: function)
//    }
//}
