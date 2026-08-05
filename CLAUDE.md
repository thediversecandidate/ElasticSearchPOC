# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## SECURITY WARNING — read before touching anything

`ElasticSearchPOC/Server.swift` previously had a hardcoded
`Authorization: Token ...` value and a hardcoded server IP — the same
token that was also hardcoded in the `Webscraping` repo. **This repository
is public**, so that token must be treated as permanently compromised even
now that the code no longer contains it literally.

### Secrets remediation status

Code fixed: `Server.swift` now reads `Secrets.apiBaseURL` /
`Secrets.apiToken` instead of hardcoded literals. `Secrets.swift` is
gitignored — copy `ElasticSearchPOC/Secrets.swift.example` to
`ElasticSearchPOC/Secrets.swift` (same directory) and fill in a real token
to build/run locally; do not commit that file. You'll also need to add
`Secrets.swift` to the Xcode target manually the first time (drag it into
the `ElasticSearchPOC` group in Xcode) since the gitignored file isn't
referenced in the checked-in `.xcodeproj`.

**Still needs action outside this repo:** the actual token value needs
rotating server-side (see the `Webscraping` repo's CLAUDE.md — same token,
same fix needed there). Nothing in this repo can rotate it; that's a
Django-admin action.

## What this is

A SwiftUI iOS/macOS proof-of-concept client for the `Webscraping` repo's
Django API — a search box + card grid of results, with an in-app `WebView`
to open an article without leaving the app. README describes it plainly:
"Creating a FrontEnd for our webscraper!"

## Structure

- `ElasticSearchPOC/Server.swift` — the only networking code: one
  `search(for:maxResultCount:)` call to `/articles/search/<query>/<max>` on
  the Django backend (base URL/token from `Secrets.swift`), returning a
  Combine `DataTaskPublisher`.
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
