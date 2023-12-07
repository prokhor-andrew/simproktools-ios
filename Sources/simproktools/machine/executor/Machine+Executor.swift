//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 04.12.2023.
//

import simprokmachine


public extension Machine {
    
    private actor ExecutorHolder<Id: Hashable, Payload, Data, Object, Sub> where Input == ExecutorInput<Id, Payload>, Output == ExecutorOutput<Id, Data> {
        
        private let logger: (Loggable) -> Void
        
        private let object: Object
        private let onCreate: (Id, Object, Payload, @escaping (Data, Bool) -> Void) throws -> Sub
        private let onDestroy: (Id, Object, Sub) -> Void
        
        private var callback: MachineCallback<Output>?
        private var subscriptions: [Id: Sub] = [:]
        
        // executor start
        
        private var executor: Task<Void, Never>?
        
        private var tasks: [() async -> Void] = []
        
        private func execute() {
            if tasks.isEmpty {
                executor?.cancel()
                executor = nil
            } else {
                guard executor == nil else { return }
                    
                executor = Task {
                    while true {
                        if tasks.isEmpty || Task.isCancelled {
                            break
                        }
                        
                        let task = tasks[0]
                        await task()
                        tasks.remove(at: 0)
                    }
                    executor = nil
                }
            }
        }
        
        // executor end
        
        init(
            _ object: Object,
            onCreate: @escaping (Id, Object, Payload, @escaping (Data, Bool) -> Void) throws -> Sub,
            onDestroy: @escaping (Id, Object, Sub) -> Void,
            logger: @escaping (Loggable) -> Void
        ) {
            self.object = object
            self.onCreate = onCreate
            self.onDestroy = onDestroy
            self.logger = logger
        }
        
        func onChange(_ callback: MachineCallback<Output>?) {
            self.callback = callback
            if callback == nil {
                subscriptions.forEach { onDestroy($0, object, $1) }
                subscriptions = [:]
                tasks = []
                executor?.cancel()
                executor = nil
            }
        }
        
        func onProcess(input: Input) async {
            switch input {
            case .launch(let id, let payload):
                if subscriptions[id] == nil {
                    do {
                        subscriptions[id] = try onCreate(id, object, payload, { [self] data, isLast in
                            if isLast, let subscription = subscriptions[id] {
                                onDestroy(id, object, subscription)
                                subscriptions[id] = nil
                            }
                            
                            tasks.append { [self] in await callback?(.didReceive(id: id, data: data, isLast: isLast)) }
                            execute()
                        })
                        
                        await callback?(.didLaunchSucceed(id: id))
                    } catch let error {
                        await callback?(.didLaunchFail(id: id, error: error))
                    }
                } else {
                    logger(ExecutorLoggable.guardedLaunch(id: id))
                }
            case .cancel(let id):
                if let subscription = subscriptions[id] {
                    onDestroy(id, object, subscription)
                    subscriptions[id] = nil
                    await callback?(.didCancel(id: id))
                } else {
                    logger(ExecutorLoggable.guardedCancel(id: id))
                }
            }
        }
    }
    
    static func executor<Id: Hashable, Payload, Data, Object, Sub>(
        object: @escaping () -> Object,
        onCreate: @escaping (Id, Object, Payload, @escaping (Data, Bool) -> Void) throws -> Sub,
        onDestroy: @escaping (Id, Object, Sub) -> Void
    ) -> Machine<Input, Output> where Input == ExecutorInput<Id, Payload>, Output == ExecutorOutput<Id, Data> {
        Machine { id, logger in
            ExecutorHolder<Id, Payload, Data, Object, Sub>(
                object(),
                onCreate: onCreate,
                onDestroy: onDestroy,
                logger: logger
            )
        } onChange: { obj, callback in
            obj.onChange(callback)
        } onProcess: { obj, input in
            await obj.onProcess(input: input)
        }
    }
}
