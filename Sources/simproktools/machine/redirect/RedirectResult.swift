//
// Created by Andriy Prokhorenko on 13.02.2023.
//


public enum RedirectResult<T> {
    case prop
    case back(T)

    public var value: T? {
        switch self {
        case .prop:
            return nil
        case .back(let value):
            return value
        }
    }

    public var isProp: Bool {
        value == nil
    }

    public var isBack: Bool {
        !isProp
    }
}
