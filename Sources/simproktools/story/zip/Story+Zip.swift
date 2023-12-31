//
//  File.swift
//
//
//  Created by Andriy Prokhorenko on 27.10.2023.
//

import simprokstate
import simprokmachine


public extension Story {

    private static func _zip<each P>(
        _ story: (repeat Story<each P, Event, Loggable>),
        function: @escaping (_ tuple: (repeat each P)) -> Payload
    ) -> Story<Payload, Event, Loggable> {
        Story(payload: function((repeat (each story).payload))) { extras, event in
      
            let tuple: (repeat (Story<each P, Event, Loggable>, Bool)) = (repeat (each story).transitOrSame(event, extras.machineId, extras.logger))
            
            var array: [Bool] = []
            repeat array.append((each tuple).1)
            
            var isTransitioned = false
            for item in array {
                if !item {
                    isTransitioned = true
                    break
                }
            }
            
            if !isTransitioned {
                return nil
            } else {
                return _zip((repeat (each tuple).0), function: function)
            }
        }
    }
    
    private func transitOrSame(_ event: Event, _ machineId: String, _ logger: MachineLogger<Loggable>) -> (Story<Payload, Event, Loggable>, Bool) {
        if let newStory = transit(event, machineId, logger) {
            (newStory, true)
        } else {
            (self, false)
        }
    }
    
    static func zip<each P>(
        _ story: repeat Story<each P, Event, Loggable>,
        function: @escaping (repeat each P) -> Payload
    ) -> Story<Payload, Event, Loggable> {
        _zip((repeat (each story)), function: { (p: (repeat each P)) in
            function(repeat each p)
        })
    }
}
