//
//  Server.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/7/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import Foundation

class Server {
	static let instance = Server()

	let url = Secrets.apiBaseURL
	let session = URLSession.shared

	func search(for string: String, maxResultCount: Int) -> URLSession.DataTaskPublisher {

		let url = self.url.appendingPathComponent("/articles/search/\(string)/\(maxResultCount)")
		var request = URLRequest(url: url)

		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Token \(Secrets.apiToken)", forHTTPHeaderField: "Authorization")

		return self.session.dataTaskPublisher(for: request)
	}
}
