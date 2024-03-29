//
//  File.swift
//  
//
//  Created by Andriy Prokhorenko on 29.12.2023.
//

import simprokstate


public extension Story {
    
    func mapPayload<R>(function: @escaping (Payload) -> R) -> Story<R, Event, Loggable> {
        Story<R, Event, Loggable>(payload: function(payload)) { extras, event in
            transit(event, extras.machineId, extras.logger)?.mapPayload(function: function)
        }
    }
}
