//
//  FactsGroup.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//
import ObjectMapper

public struct FactsGroup: ImmutableMappable {
    /// stream url
    public let title: String?
    public let rows: [Fact]
    
    /// required init
    public init(map: Map) throws {
        title = try? map.value("title")
        rows = try map.value("rows")
    }
}
