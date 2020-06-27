//
//  ContentView.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/7/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import SwiftUI
import Combine

struct SearchView: View {
	@State var results: [SearchResult] = []
	@State var publisher: AnyCancellable? = nil
	@State var selectedIndex: Int?
	@State var searchText = ""
	@State var lastSearchText = ""
	@State var searchInProgress = false
	@State var selectedURL: URL?
	@State var maxResultCount = 10

	var cardSize = CGSize(width: 300, height: 200)
	func across(in geo: GeometryProxy) -> Int {
		max(1, Int(geo.size.width / cardSize.width))
	}
	func firstRowIndices(in geo: GeometryProxy) -> [Int] {
		let across = self.across(in: geo)
		let rows = (results.count / across) + (results.count % across == 0 ? 0 : 1)
		
		return (0..<rows).map { $0 * across }
	}
	
	var body: some View {
		Group() {
			if self.selectedURL != nil {
				VStack() {
					HStack() {
						Button(action: { self.selectedURL = nil }) {
							Text("Back")
						}
						.padding()
						Spacer()
					}
					WebView(request: URLRequest(url: self.selectedURL!))
				}
				.animation(.easeInOut)
			} else {
				VStack() {
					HStack() {
						Spacer()
						Text("Search for: ")
						TextField("Text", text: $searchText) {
							self.performSearch()
						}
						Spacer()
						if searchText != lastSearchText {
							Button(action: { self.performSearch() }) { Text("Search") }
						}
						
						HStack() {
							Text("Limit")
							NumericField("", number: $maxResultCount)
							Stepper("", value: $maxResultCount)
						}
							.frame(width: 150)
					}
					.padding()
					
					GeometryReader() { geo in
						ScrollView() {
							VStack(alignment: .leading) {
								ForEach(self.firstRowIndices(in: geo), id: \.self) { start in
									HStack() {
										ForEach((start..<min(start + self.across(in: geo), self.results.count)), id: \.self) { index in
											SearchResultView(selectedURL: self.$selectedURL, result: self.results[index], size: self.cardSize)
										}
									}
								}
								if self.searchInProgress { HStack() { Text("Searching…") }.frame(maxWidth: .infinity) }
							}
						}
					}
						.padding()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						
						.onAppear() {
						//	self.searchText = "Pandemic"
							self.performSearch()
						}
				}
			}
		}
	}
	
	func performSearch() {
		lastSearchText = searchText
		self.searchInProgress = true
		self.publisher = Server.instance.search(for: self.searchText, maxResultCount: self.maxResultCount)
			.map { $0.data }
			.decode(type: [SearchResult].self, decoder: JSONDecoder())
			.replaceError(with: [])
			.eraseToAnyPublisher()
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .failure(let err):
					self.searchInProgress = false
					print("Received Error: \(err)")
				default: break
				}
			}, receiveValue: { results in
				self.searchInProgress = false
				self.results = results
			})
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}
