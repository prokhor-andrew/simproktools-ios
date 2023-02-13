//
// Created by Andriy Prokhorenko on 13.02.2023.
//

import simprokmachine


public extension Machine {

    private class Holder<Object: AnyObject> {

        weak var object: Object?

        init(_ object: Object) {
            self.object = object
        }
    }

    static func weak<Object: AnyObject>(
            _ object: Object,
            isProcessOnMain: Bool = true, // by default it's true, cause if self is passed into more than one machine, they may simultaneously modify the same properties causing race conditions.
            onProcess: @escaping TriHandler<Object, Input?, Handler<Output>>,
            onClearUp: @escaping Handler<Object> = { _ in
            }
    ) -> Machine<Input, Output> {
        Machine(
                Holder(object),
                isProcessOnMain: isProcessOnMain,
                onProcess: { holder, input, callback in
                    guard let object = holder.object else {
                        return
                    }
                    onProcess(object, input, callback)
                },
                onClearUp: { holder in
                    guard let object = holder.object else {
                        return
                    }
                    onClearUp(object)
                }
        )
    }
}