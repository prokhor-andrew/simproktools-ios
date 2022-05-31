# simproktools

```simproktools``` is a small library consisting of useful machines for [simprokmachine](https://github.com/simprok-dev/simprokmachine-ios) framework. 

## Installation

As for now, ```Swift Package Manager``` is the only option to use for adding the framework into your project. 
Once you have your Swift package set up, adding ```simprokmachine``` as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/simprok-dev/simproktools-ios.git", .upToNextMajor(from: "1.1.2"))
]
```

## BasicMachine

A machine with an injectable processing behavior. 

```Swift

_ = BasicMachine<Input, Output>(queue: .new /* or .main */) { input, callback in
    // any processing logic
}
```

Creates a unique serial queue to render its input by default. Accepts ```queue``` parameter to modify this behavior.

## WeakMachine

A machine with an injectable processing behavior over the weakly referenced injected object. 

```Swift

let object: AnyObject = ...
    
_ = WeakMachine<Input, Output>(object) { weakObjet, input, callback in
    // any processing logic
}
```

Works on the main queue.

## JustMachine

A machine that emits the injected value when subscribed and every time input is received.

```Swift

_ = JustMachine<Input, Int>(0) // Int can be replaced with any type
```

Works on the main queue.


## SingleMachine

A machine that emits the injected value *when subscribed*.

```Swift

_ = SingleMachine<Input, Int>(0) // Int can be replaced with any type
```

Works on the main queue.


## ValueMachine

A machine that accepts a value as input and immediately emits it as output. When subscribed - emits `nil`.

```Swift

_ = ValueMachine<Int>() // Int can be replaced with any type
```

Works on the main queue.


## NeverMachine

A machine that when subscribed or receives input - ignores it, never emitting output.

```Swift

_ = NeverMachine<Input, Output>() 
```

Works on the main queue.


## ReducerMachine

A machine that receives input, reduces it into state and emits it.

```Swift

// Bool and Int can be replaced with any types

_ = ReducerMachine<Bool, Int>(Int(0)) { (state: Int, value: Bool) -> ReducerResult<Int> in
    // return ReducerResult.set(0) // 0 will be a new State and will be passed as output 
    // return ReducerResult.skip // state won't be changed and passed as output
}

```

Creates a unique serial queue to render its input by default. Accepts ```queue``` parameter to modify this behavior.


## ClassicMachine

A machine that receives input, reduces it into state and array of outputs that are emitted.

```Swift

// Bool Void, and Int can be replaced with any types

_ = ClassicMachine<Bool, Void, Int>(
    ClassicResult<Bool, Int>.set(false, outputs: 0, 1, 2) // initial state and initial outputs that are emitted when machine is subscribed to
) { (state: Bool, event: Void) -> ClassicResult<Bool, Int> in
    return ClassicResult<Bool, Int>.set(true, outputs: 3, 4, 5) // new state `true` and outputs `3, 4, 5` 
}

```

Creates a unique serial queue to render its input by default. Accepts ```queue``` parameter to modify this behavior.

## Scan operator

Takes `self` and applies specific behavior.
When parent machine sends new input, it is either reduced into new child state and sent to the `self` or mapped into parent output and emitted back.
When `self` sends new output, it is either reduced into new child state and sent back to the `self` or mapped into parent output and emitted.

```Swift

// All the types can be replaced with anything else.

let machine: Machine<Bool, Int> = ...

let result: Machine<String, Void> = machine.scan(true) { (state: Bool, event: ScanInput<String, Int>) -> ScanOutput<Void, Bool> in 
    // event has either come from parent as input or from child as output.
    // output should either go to the parent as output or to the child as new input and state.
    
    // Return
    // ScanOutput<Void, Bool>.state(Bool) // when input has to be sent to the child machine AND state has to be changed.
    // ScanOutput<Void, Bool>.event(Void) // when output has to be sent to the parent machine.=
    ...
}
```

## ConnectableMachine

A machine for dynamic creation and connection of other machines.


```Swift

_ = ConnectableMachine<BasicConnection<Input, Output> /* or any class that conforms to Connection*/>(
    BasicConnection([ /* machines for connection go here */ ])
) { connection, input in 
    // Return
    // ConnectionType<BasicConnection<Input, Output>>.reduce(BasicConnection<Input, Output>([ /* machines for connection go here */ ])) // when we want to connect new array of machines
    // ConnectionType<BasicConnection<Input, Output>>.inward // when we want to pass input to the connected machines
}
```

Creates a unique serial queue when connecting new machines dynamically. 
