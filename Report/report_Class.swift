//
//  report_Class.swift
//  Report.
//
//  Created by Amogh Kalyan on 11/28/21.
//

import Foundation

class Article: Codable {
    let title: String
    let description: String
    let url: String
    let image: String
    let publishedAt: String
    let source: String

    init(title: String, description: String, url: String, image: String, publishedAt: String, source: String) {
        self.title = title
        self.description = description
        self.url = url
        self.image = image
        self.publishedAt = publishedAt
        self.source = source
    }
}
