//
//  SearchResult.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/7/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import Foundation

struct SearchResult: Codable, Identifiable {
	let url: URL
	let title: String
	let body: String
	let article_summary: String
	let list_of_keywords: String

	var id: String { url.absoluteString }
}
