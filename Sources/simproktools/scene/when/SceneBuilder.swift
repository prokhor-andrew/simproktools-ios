//
// Created by Andriy Prokhorenko on 17.02.2023.
//

import simprokmachine
import simprokstate

public struct SceneBuilder<Trigger, Effect> {

    private let featureSupplier: Mapper<Mapper<Trigger, SceneTransition<Trigger, Effect>?>, Scene<Trigger, Effect>>

    public init() {
        featureSupplier = Scene.create
    }

    private init(_ featureSupplier: @escaping Mapper<Mapper<Trigger, SceneTransition<Trigger, Effect>?>, Scene<Trigger, Effect>>) {
        self.featureSupplier = featureSupplier
    }

    public func when(
            _ function: @escaping Mapper<Trigger, [Effect]?>
    ) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder<Trigger, Effect> { transit in
            featureSupplier {
                if let effects = function($0) {
                    return SceneTransition(
                            Scene.create(transit: transit),
                            effects: effects
                    )
                } else {
                    return nil
                }
            }
        }
    }

    public func when(
            is trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
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
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        when(is: trigger, send: effects)
    }

    public func when(
            not trigger: Trigger,
            send effects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
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
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        when(not: trigger, send: effects)
    }

    public func loop(
            _ function: @escaping Mapper<Trigger, SceneLoop<Effect>>
    ) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder { mapper in
            func _transit(_ trigger: Trigger) -> SceneTransition<Trigger, Effect> {
                switch function(trigger) {
                case .loop(let effects):
                    return SceneTransition(Scene.create(transit: _transit), effects: effects)
                case .exit(let effects):
                    return SceneTransition(Scene.create(transit: mapper), effects: effects)
                }
            }
            
            return featureSupplier(_transit)
        }
    }

    public func loop(
           is trigger: Trigger,
           send loopEffects: [Effect],
           exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop {
           if $0 == trigger {
               return .exit(loopEffects)
           } else {
               return .loop(exitEffects)
           }
       }
    }

    public func loop(
            is trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            is trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            is trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(is: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop {
            if $0 != trigger {
                return .exit(loopEffects)
            } else {
                return .loop(exitEffects)
            }
        }
    }

    public func loop(
            not trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: [Effect]
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: Trigger,
            send loopEffects: [Effect],
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func loop(
            not trigger: Trigger,
            send loopEffects: Effect...,
            exit exitEffects: Effect...
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        loop(not: trigger, send: loopEffects, exit: exitEffects)
    }

    public func then(
            _ function: @escaping Mapper<Trigger, SceneTransition<Trigger, Effect>?>
    ) -> Scene<Trigger, Effect> {
        featureSupplier { event in
            if let transition = function(event) {
                return transition
            } else {
                return nil
            }
        }
    }

    public func then(
            is trigger: Trigger,
            execute transition: @autoclosure @escaping Supplier<SceneTransition<Trigger, Effect>>
    ) -> Scene<Trigger, Effect> where Trigger: Equatable {
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
    ) -> Scene<Trigger, Effect> where Trigger: Equatable {
        then { event in
            if event != trigger {
                return transition()
            } else {
                return nil
            }
        }
    }
    
    public func side(
        function: @escaping Mapper<Trigger, SceneTransition<Trigger, Effect>?>
    ) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder { transit in
            featureSupplier {
                if let transition = function($0) {
                    return transition
                } else {
                    return transit($0)
                }
            }
        }
    }
    
    public func side(
        is trigger: Trigger, send effects: [Effect], to scene: Scene<Trigger, Effect> = .finale()
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        side {
            if trigger == $0 {
                return SceneTransition(scene, effects: effects)
            } else {
                return nil
            }
        }
    }
    
    public func side(
        not trigger: Trigger, send effects: [Effect], to scene: Scene<Trigger, Effect> = .finale()
    ) -> SceneBuilder<Trigger, Effect> where Trigger: Equatable {
        side {
            if trigger != $0 {
                return SceneTransition(scene, effects: effects)
            } else {
                return nil
            }
        }
    }
    
    public func switchTo(doneOnFinale: Bool = true, function: @escaping Mapper<Trigger, SceneTransition<Trigger, Effect>?>) -> SceneBuilder<Trigger, Effect> {
        SceneBuilder { transit in
            featureSupplier {
                if let transition = transit($0) {
                    return SceneTransition(
                        transition.state.switchTo(doneOnFinale: doneOnFinale) { _, event in
                            function(event)
                        },
                        effects: transition.effects
                    )
                } else {
                    return nil
                }
            }
        }
    }
}
