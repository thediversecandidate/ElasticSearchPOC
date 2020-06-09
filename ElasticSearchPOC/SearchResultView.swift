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
					
					Text(result.body)
						.font(.body)
						.lineLimit(5)
				}
					.padding()
			}
			.frame(width: size.width, height: size.height)
		}
		.buttonStyle(PlainButtonStyle())
	}
	
}
