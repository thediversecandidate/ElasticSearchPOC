//
//  ContentView.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/7/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
	var searchText = "pandemic"
	@State var results: [SearchResult] = []
	@State var publisher: AnyCancellable? = nil
	@State var selectedIndex: Int?

	var body: some View {
		ScrollView() {
			VStack() {
				ForEach(results.indices, id: \.self) { index in
					Button(action: {
						self.selectedIndex = (self.selectedIndex == index) ? nil : index }) {
							VStack() {
								Text(self.results[index].title)
									.lineLimit(nil)
									.multilineTextAlignment(.leading)
									.font(.title)
								
								Text(self.results[index].body)
									.lineLimit(index == self.selectedIndex ? nil : 2)
									.multilineTextAlignment(.leading)
									.font(.body)
							}
								.frame(maxWidth: 600)
					}
						.buttonStyle(BorderlessButtonStyle())
				}
			}
		}
			.padding()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			.onAppear() {
				self.publisher = Server.instance.search(for: self.searchText)
					.map { $0.data }
					.decode(type: [SearchResult].self, decoder: JSONDecoder())
					.replaceError(with: [])
					.eraseToAnyPublisher()
					.receive(on: DispatchQueue.main)
					.sink(receiveCompletion: { completion in
						switch completion {
						case .failure(let err): print("Received Error: \(err)")
						default: break
						}
					}, receiveValue: { results in
						self.results = results
					})
		}
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
