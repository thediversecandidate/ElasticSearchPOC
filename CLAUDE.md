# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## SECURITY WARNING — read before touching anything

`ElasticSearchPOC/Server.swift` has a hardcoded `Authorization: Token ...`
value and a hardcoded server IP. **This repository is public, and this is
the same API token that's also hardcoded in the `Webscraping` repo's
`django/derrick/README.MD`/`settings.py`** — it's been committed to
plaintext in at least two public repos, which makes rotating it more
urgent, not less. Do not copy this token into any new file, and if asked to
work on auth here, move it to a build setting / secrets mechanism (e.g. an
Xcode `.xcconfig` not checked in, or a keychain-backed value at runtime)
rather than another hardcoded string, and flag to the user that the
existing token needs rotating server-side.

## What this is

A SwiftUI iOS/macOS proof-of-concept client for the `Webscraping` repo's
Django API — a search box + card grid of results, with an in-app `WebView`
to open an article without leaving the app. README describes it plainly:
"Creating a FrontEnd for our webscraper!"

## Structure

- `ElasticSearchPOC/Server.swift` — the only networking code: one
  `search(for:maxResultCount:)` call to `/articles/search/<query>/<max>` on
  the (hardcoded-IP) Django backend, returning a Combine
  `DataTaskPublisher`.
- `ElasticSearchPOC/SearchResult.swift` — `Codable` model matching the
  Django API's article JSON shape (`url`, `title`, `body`,
  `article_summary`, `list_of_keywords`) — keep this in sync with the
  `ArticleSerializer` fields in the `Webscraping` repo's `api/serializers.py`
  if that API's response shape changes.
- `ElasticSearchPOC/SearchView.swift` — the main SwiftUI view: search field,
  result-count stepper, a card grid computed from available width, and a
  Combine pipeline (`performSearch()`) that decodes results and swallows
  errors into an empty list (`.replaceError(with: [])`) rather than
  surfacing them to the UI — worth tightening if error visibility matters.
- `ElasticSearchPOC/SearchResultView.swift` — one result card.
- `ElasticSearchPOC/WebView.swift` — `UIViewRepresentable`/`WKWebView`
  wrapper used for the in-app article reader.
- `NumericField.swift` — a reusable numeric text field used for the
  "Limit" stepper input.

## Building

Standard Xcode project (`ElasticSearchPOC.xcodeproj`) — open and run/build
from Xcode; there's no CLI build script or test target in this repo.
