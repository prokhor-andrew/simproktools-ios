//
// Created by Andriy Prokhorenko on 14.02.2023.
//

import simprokstate

public extension Story {

    func asExtTriggerExtEffect<IntTrigger, IntEffect>() -> Outline<IntTrigger, IntEffect, Event, Event> {
        if let transit {
            let outline: Outline<IntTrigger, IntEffect, Event, Event> = Outline.create { event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asExtTriggerExtEffect(),
                                effects: .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                case .int:
                    return OutlineTransition(outline)
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntEffectExtTrigger<IntTrigger, ExtEffect>() -> Outline<IntTrigger, Event, Event, ExtEffect> {
        if let transit {
            let outline: Outline<IntTrigger, Event, Event, ExtEffect> = Outline.create { event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntEffectExtTrigger(),
                                effects: .int(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                case .int:
                    return OutlineTransition(outline)
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerExtEffect<IntEffect, ExtTrigger>() -> Outline<Event, IntEffect, ExtTrigger, Event>  {
        if let transit {
            let outline: Outline<Event, IntEffect, ExtTrigger, Event> = Outline.create { event in
                switch event {
                case .ext:
                    return OutlineTransition(outline)
                case .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerExtEffect(),
                                effects: .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerIntEffect<ExtTrigger, ExtEffect>() -> Outline<Event, Event, ExtTrigger, ExtEffect> {
        if let transit {
            let outline: Outline<Event, Event, ExtTrigger, ExtEffect> = Outline.create { event in
                switch event {
                case .ext:
                    return OutlineTransition(outline)
                case .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerIntEffect(),
                                effects: .int(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntEffectExtTriggerExtEffect<IntTrigger>() -> Outline<IntTrigger, Event, Event, Event> {
        if let transit {
            let outline: Outline<IntTrigger, Event, Event, Event> = Outline.create { event in
                switch event {
                case .ext(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntEffectExtTriggerExtEffect(),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                case .int:
                    return OutlineTransition(outline)
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerIntEffectExtEffect<ExtTrigger>() -> Outline<Event, Event, ExtTrigger, Event> {
        if let transit {
            let outline: Outline<Event, Event, ExtTrigger, Event> = Outline.create { event in
                switch event {
                case .ext:
                    return OutlineTransition(outline)
                case .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerIntEffectExtEffect(),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerIntEffectExtTrigger<ExtEffect>() -> Outline<Event, Event, Event, ExtEffect> {
        if let transit {
            let outline: Outline<Event, Event, Event, ExtEffect> = Outline.create { event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerIntEffectExtTrigger(),
                                effects: .int(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerExtTriggerExtEffect<IntEffect>() -> Outline<Event, IntEffect, Event, Event> {
        if let transit {
            let outline: Outline<Event, IntEffect, Event, Event> = Outline.create { event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerExtTriggerExtEffect(),
                                effects: .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }

    func asIntTriggerIntEffectExtTriggerExtEffect() -> Outline<Event, Event, Event, Event> {
        if let transit {
            let outline: Outline<Event, Event, Event, Event> = Outline.create { event in
                switch event {
                case .ext(let value),
                     .int(let value):
                    if let new = transit(value) {
                        return OutlineTransition(
                                new.asIntTriggerIntEffectExtTriggerExtEffect(),
                                effects: .int(value), .ext(value)
                        )
                    } else {
                        return OutlineTransition(outline)
                    }
                }
            }

            return outline
        } else {
            return .finale()
        }
    }
}