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
	
	let url = URL(string: "http://34.234.193.247")!
	let session = URLSession.shared
	
	func search(for string: String, maxResultCount: Int) -> URLSession.DataTaskPublisher {
		
		let url = self.url.appendingPathComponent("/articles/search/\(string)/\(maxResultCount)")
		var request = URLRequest(url: url)
		
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("Token fd314d4436dfdc9fd990822cd1e483d951c7dfd6", forHTTPHeaderField: "Authorization")
		
//		let task = self.session.dataTask(with: request) { data, response, error in
//
//		}
		
		return self.session.dataTaskPublisher(for: request)
	}
}
