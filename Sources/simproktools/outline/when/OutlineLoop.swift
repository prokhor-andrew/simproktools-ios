//
// Created by Andriy Prokhorenko on 19.02.2023.
//

import simprokstate

public enum OutlineLoop<IntEffect, ExtEffect> {
    case loop([FeatureEvent<IntEffect, ExtEffect>])
    case exit([FeatureEvent<IntEffect, ExtEffect>])
}
