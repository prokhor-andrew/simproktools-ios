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
//    func redirectOutput(
//        _ function: @escaping (Output, String, MachineLogger) -> Input?
//    ) -> Machine<Input, Output> {
//        redirectOutput(with: Void()) { state, output, id, logger in
//            (state, function(output, id, logger))
//        }
//    }
//
//    func redirectOutput<State>(
//        with state: @escaping @autoclosure () -> State,
//        _ function: @escaping (State, Output, String, MachineLogger) -> (newState: State, input: Input?)
//    ) -> Machine<Input, Output> {
//        Machine { machineId in
//            Feature.classic(DataMachines(state(), machines: self)) { extras, trigger in
//                switch trigger {
//                case .int(let output):
//                    let (newState, redirectResult) = function(extras.machines.data, output, machineId, extras.logger)
//                    if let input = redirectResult {
//                        return (DataMachines(newState, machines: extras.machines.machines), [.int(input)])
//                    } else {
//                        return (DataMachines(newState, machines: extras.machines.machines), [.ext(output)])
//                    }
//                case .ext(let input):
//                    return (extras.machines, [.int(input)])
//                }
//            }
//        }
//    }
//}
