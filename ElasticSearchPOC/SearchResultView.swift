//
//  SearchResultView.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/9/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import SwiftUI

struct SearchResultView: View {
	@Binding var selectedURL: URL?
	let result: SearchResult
	var size = CGSize(width: 300, height: 250)
	
	var body: some View {
		Button(action: {
			self.selectedURL = self.result.url
		}) {
			ZStack() {
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.white)
				
				RoundedRectangle(cornerRadius: 12)
					.stroke(Color.black, lineWidth: 2)
					.shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 8)
				
				VStack() {
					Text(result.title)
						.font(.title)
						.lineLimit(2)
						.foregroundColor(.black)
					
					Text(result.article_summary.isEmpty ? result.body : result.article_summary)
						.font(.body)
						.lineLimit(5)
						.foregroundColor(.black)
					
					if !result.list_of_keywords.isEmpty {
						HStack() {
							Text(result.list_of_keywords)
								.font(.caption).fontWeight(.semibold)
								.lineLimit(1)
								.foregroundColor(Color(white: 0.3))
							Spacer()
						}
						.padding(.top, 5)
					}
				}
					.padding()
			}
			.frame(width: size.width, height: size.height)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
}

struct SearchResultView_Previews: PreviewProvider {
	static var previews: some View {
		SearchResultView(selectedURL: .constant(nil), result: .sample)
	}
}

extension SearchResult {
	static let sample = SearchResult(url: URL(string: "https://cnn.com")!, title: "Title", body: "Body", article_summary: "Summary", list_of_keywords: "keywwords")
}
