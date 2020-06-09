//
//  WebView.swift
//  ElasticSearchPOC
//
//  Created by Ben Gottlieb on 6/9/20.
//  Copyright © 2020 The Diverse Candidate. All rights reserved.
//

import SwiftUI
import WebKit
  
struct WebView : NSViewRepresentable {
    let request: URLRequest
      
    func makeNSView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateNSView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
      
}
