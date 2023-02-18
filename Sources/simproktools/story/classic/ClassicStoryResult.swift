//
// Created by Andriy Prokhorenko on 18.02.2023.
//


public enum ClassicStoryResult<State> {
    case finale
    case skip
    case next(State)


    public var isFinale: Bool {
        switch self {
        case .finale:
            return true
        default:
            return false
        }
    }

    public var isSkip: Bool {
        switch self {
        case .skip:
            return true
        default:
            return false
        }
    }

    public var next: State? {
        switch self {
        case .next(let value):
            return value
        default:
            return nil
        }
    }

    public var isNext: Bool {
        next != nil
    }
}
