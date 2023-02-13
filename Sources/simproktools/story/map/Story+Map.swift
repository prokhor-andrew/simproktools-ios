//
// Created by Andriy Prokhorenko on 11.02.2023.
//

import simprokmachine
import simprokstate

public extension Story {

    func map<REvent>(
            _ function: @escaping Mapper<REvent, Event?>
    ) -> Story<REvent> {
        Story<REvent> { event in
            if let mapped = function(event) {
                if let new = transit(mapped) {
                    return new.map(function)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
}