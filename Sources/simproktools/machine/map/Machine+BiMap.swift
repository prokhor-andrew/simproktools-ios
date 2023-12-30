////
//// Created by Andriy Prokhorenko on 20.02.2023.
////
//
//import simprokmachine
//import simprokstate
//
//
//public extension Machine {
//
//    func biMap<RInput, ROutput>(
//        mapInput: @escaping (RInput, String, MachineLogger) -> [Input],
//        mapOutput: @escaping (Output, String, MachineLogger) -> [ROutput]
//    ) -> Machine<RInput, ROutput> {
//        biMap { Void() } mapInput: { state, input, id, logger in
//            (state, mapInput(input, id, logger))
//        } mapOutput: { state, output, id, logger in
//            (state, mapOutput(output, id, logger))
//        }
//    }
//    
//    func biMap<State, RInput, ROutput>(
//        with state: @escaping () -> State,
//        mapInput: @escaping (State, RInput, String, MachineLogger) -> (newState: State, inputs: [Input]),
//        mapOutput: @escaping (State, Output, String, MachineLogger) -> (newState: State, outputs: [ROutput])
//    ) -> Machine<RInput, ROutput> {
//        Machine<RInput, ROutput> { machineId in
//            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
//                switch trigger {
//                case .int(let output):
//                    let (newState, outputs) = mapOutput(extras.machines.data, output, machineId, extras.logger)
//
//                    return (
//                        DataMachines(newState, machines: extras.machines.machines),
//                        outputs.map { .ext($0) }
//                    )
//                case .ext(let input):
//                    let (newState, inputs) = mapInput(extras.machines.data, input, machineId, extras.logger)
//
//                    return (
//                        DataMachines(newState, machines: extras.machines.machines),
//                        inputs.map { .int($0) }
//                    )
//                }
//            }
//        }
//    }
//}
