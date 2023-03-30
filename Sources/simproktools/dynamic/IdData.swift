//
// Created by Andriy Prokhorenko on 18.02.2023.
//


public struct IdData<Id, Data> {

    public let id: Id
    public let data: Data

    public init(
            id: Id,
            data: Data
    ) {
        self.id = id
        self.data = data
    }
}
