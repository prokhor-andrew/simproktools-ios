//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public struct SceneBuilder<Trigger, Effect> {

    private let featureSupplier: Mapper<Mapper<Trigger, SceneTransition<Trigger, Effect>>, Scene<Trigger, Effect>>

    public init() {
        featureSupplier = Scene.create
    }

    private init(_ featureSupplier: @escaping Mapper<Mapper<Trigger, SceneTransition<Trigger, Effect>>, Scene<Trigger, Effect>>) {
        self.featureSupplier = featureSupplier
    }

    public func when(
            _ function: @escaping Mapper<Trigger, [Effect]?>
    ) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder<Trigger, Effect> { transit in

            let scene = featureSupplier {
                if let effects = function($0) {
                    return SceneTransition(
                            Scene.create(transit: transit),
                            effects: effects
                    )
                } else {
                    return SceneTransition(scene)
                }
            }

            return scene
        }
    }

    public func when(
            is trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        when { event in
            if event == trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    public func when(
            is trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        when(is: trigger, send: effects)
    }

    public func when(
            not trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        when { event in
            if event != trigger {
                return effects
            } else {
                return nil
            }
        }
    }

    public func when(
            not trigger: Trigger,
            send effects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        when(not: trigger, send: effects)
    }

    public func then(
            _ function: @escaping Mapper<Trigger, SceneTransition<Trigger, Effect>?>
    ) -> Scene<Trigger, Effect> {
        let scene = featureSupplier { event in
            if let transition = function(event) {
                return transition
            } else {
                return SceneTransition(scene)
            }
        }

        return scene
    }

    public func then(
            is trigger: Trigger,
            execute transition: @autoclosure @escaping Supplier<SceneTransition<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        then { event in
            if event == trigger {
                return transition()
            } else {
                return nil
            }
        }
    }

    public func then(
            not trigger: Trigger,
            execute transition: @autoclosure @escaping Supplier<SceneTransition<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> where Trigger: Equatable, Effect: Equatable {
        then { event in
            if event != trigger {
                return transition()
            } else {
                return nil
            }
        }
    }
}