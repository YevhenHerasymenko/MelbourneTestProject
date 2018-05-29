//
//  Fact.swift
//  MelbourneTestProjectCore
//
//  Created by Yevhen Herasymenko on 5/28/18.
//  Copyright © 2018 Yevhen Herasymenko. All rights reserved.
//

import ObjectMapper

public struct Fact: ImmutableMappable {
    /// stream url
    public let title: String?
    public let description: String?
    public let imageURL: URL?
    
    /// required init
    public init(map: Map) throws {
        title = try? map.value("title")
        description = try? map.value("description")
        imageURL = try? map.value("imageHref", using: URLTransform())
    }
}
