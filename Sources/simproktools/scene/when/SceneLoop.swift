//
// Created by Andriy Prokhorenko on 18.02.2023.
//

import Foundation

public enum SceneLoop<Effect> {
    case loop([Effect])
    case exit([Effect])
}
