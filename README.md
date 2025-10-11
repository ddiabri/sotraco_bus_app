# SOTRACO Bus App

An unofficial Flutter application for navigating the SOTRACO bus network in Ouagadougou, Burkina Faso.

This app helps users find the most efficient bus routes from njihov departure point to their destination, including direct lines and journeys with multiple transfers.

## Features

- **Route Search**: Find direct bus routes between any two stops.
- **Intelligent Transfers**: If no direct route is available, the app will find the shortest journey with up to three transfers (four buses).
- **Distance-Based Routing**: Uses real geographical coordinates and a Dijkstra-based algorithm to find the truly shortest path, not just the one with the fewest stops.
- **Bidirectional Routes**: Understands that all bus lines run in both directions, ensuring the most efficient route is always found.
- **Interactive Route Details**: View the full list of stops for any bus line, with your departure and arrival points clearly highlighted.
- **Fare Information**: A dedicated page displaying the complete fare schedule for different ticket types and user categories.
- **Contact & Support**: Provides official SOTRACO contact information for user support.
- **Localized UI**: The entire user interface is in French to serve the local user base.
- **Performant**: Caches route data in memory to ensure a fast and responsive user experience.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)

### Installation

1. Clone the repository:
   ```sh
   git clone <your-repository-url>
   ```
2. Navigate to the project directory:
   ```sh
   cd sotraco_bus_app
   ```
3. Install the dependencies:
   ```sh
   flutter pub get
   ```

### Running the App

Run the following command to launch the app in a simulator or connected device:

```sh
flutter run
```

To run on the web, use:

```sh
flutter run -d chrome
```

## Building for Production

You can build the app for web, Android, or iOS.

### Web

```sh
flutter build web
```
The output will be in the `build/web` directory. This folder can be deployed to any static web hosting service like Firebase Hosting.

### Android

```sh
flutter build appbundle
```
This command creates a release app bundle in `build/app/outputs/bundle/release/`.

### iOS

```sh
flutter build ipa
```
This command creates a release IPA file in `build/ios/ipa/`.
