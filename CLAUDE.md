# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SOTRACO Bus App is an unofficial Flutter application for navigating the SOTRACO bus network in Ouagadougou, Burkina Faso. The app helps users find efficient bus routes between stops, supporting direct routes and multi-transfer journeys (up to 3 transfers). It uses real geographical coordinates with a Dijkstra-based algorithm to find the shortest paths by distance.

**Key Features:**
- Route search with intelligent transfer suggestions
- Distance-based routing using haversine formula
- Bidirectional route support
- French-localized UI
- In-memory route caching for performance

## Development Commands

### Running the App
```sh
flutter run                 # Run on connected device/simulator
flutter run -d chrome       # Run on web browser
```

### Building for Production
```sh
flutter build web           # Build for web (output in build/web)
flutter build appbundle     # Build Android app bundle
flutter build ipa           # Build iOS IPA file
```

### Testing and Analysis
```sh
flutter test                # Run all tests
flutter analyze             # Run static analysis
flutter pub get             # Install/update dependencies
```

## Code Architecture

### Core Data Flow

1. **Data Layer** (`lib/data/routes_data.dart`):
   - Single source of truth for all bus routes and stop coordinates
   - Implements in-memory caching via `_cachedRoutes` static variable
   - Contains hardcoded coordinate map for ~85 bus stops in Ouagadougou
   - `getAllRoutes()` returns cached data on subsequent calls
   - Stop name normalization via `getStop()` helper function

2. **Service Layer** (`lib/services/route_finder.dart`):
   - **Route Finding Algorithm**: Modified Dijkstra's algorithm that prioritizes fewest transfers, then shortest distance
   - Searches both directions on each bus line (bidirectional support)
   - `findRoutes()`: Main entry point - returns direct routes if available, otherwise finds journeys with transfers
   - `_findJourneys()`: Implements pathfinding with priority queue and visited tracking
   - `_calculateDistance()`: Haversine formula for geographic distance calculation
   - Returns top 3 shortest journeys by total distance

3. **Model Layer** (`lib/models/bus_route.dart`):
   - `BusStop`: name, latitude, longitude
   - `BusRoute`: lineNumber, name, category, stops, isSuspended flag
   - `RouteResult`: holds both direct routes and multi-leg journeys
   - `Journey`: represents route with transfers (routes list, transferStops, totalDistance)

### UI Structure

- **HomePage** (`lib/main.dart`): Main route list with category filtering (Regular/Student/Intercommunal lines)
- **RouteSearchPage** (`lib/pages/route_search_page.dart`): Search interface with autocomplete, displays direct routes and journeys with transfers
- **RouteDetailPage**: Shows complete stop list with highlighted departure/arrival points, handles bidirectional display
- **InfoPage** (`lib/pages/info_page.dart`): Fare information and SOTRACO contact details

### Important Implementation Details

**Route Search Algorithm:**
- Uses priority queue (simulated via sorted List) with `_PathNode` comparable by transfers then distance
- Visited tracking prevents revisiting stops with worse paths
- Explores both forward and backward along each route from current stop
- Transfer detection: `newTransfers = (previousRoute != currentRoute) ? transfers + 1 : transfers`
- Max 3 transfers (4 buses total) to limit search space

**Coordinate System:**
- Latitude/longitude for Ouagadougou area (approximately 12.2-12.5°N, 1.4-1.6°W)
- Missing coordinates default to (0.0, 0.0) with fallback distance of 1.0 km
- Stop name matching uses lowercase comparison with `contains()` for flexibility

**Category Colors:**
- Regular Lines: Blue
- Student Lines: Orange
- Intercommunal Lines: Purple

## Key Files to Understand

- `lib/data/routes_data.dart`: All route definitions and coordinates (~650 lines)
- `lib/services/route_finder.dart`: Pathfinding algorithm (~230 lines)
- `lib/pages/route_search_page.dart`: Search UI and results display (~640 lines)
- `lib/main.dart`: App entry point and home page with route browsing

## Project Conventions

- UI is entirely in French for the local Burkina Faso user base
- Uses Material Design 3 with green theme (`0xFF4CAF50`)
- Route categories use English internally but display French labels in UI
- Suspended routes have `isSuspended: true` and empty stops list
- Flutter SDK >=3.2.0 required
