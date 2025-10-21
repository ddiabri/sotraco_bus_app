import 'dart:math';
import '../models/bus_route.dart';

class RouteResult {
  final List<BusRoute> directRoutes;
  final List<Journey> journeys;

  RouteResult({
    required this.directRoutes,
    required this.journeys,
  });
}

class Journey {
  final List<BusRoute> routes;
  final List<BusStop> transferStops;
  final double totalDistance;

  Journey({
    required this.routes,
    required this.transferStops,
    required this.totalDistance,
  });
}

class _PathNode implements Comparable<_PathNode> {
  final BusStop stop;
  final BusRoute? route;
  final _PathNode? previous;
  final int transfers;
  final double distance;

  _PathNode(this.stop, this.route, this.previous, 
      {this.transfers = 0, this.distance = 0.0});

  @override
  int compareTo(_PathNode other) {
    if (transfers != other.transfers) {
      return transfers.compareTo(other.transfers);
    }
    return distance.compareTo(other.distance);
  }
}

class RouteFinder {
  static RouteResult findRoutes({
    required String departure,
    required String arrival,
    required List<BusRoute> allRoutes,
  }) {
    final departureNorm = departure.toLowerCase().trim();
    final arrivalNorm = arrival.toLowerCase().trim();

    final directRoutes = _findDirectRoutes(departureNorm, arrivalNorm, allRoutes);
    if (directRoutes.isNotEmpty) {
      return RouteResult(directRoutes: directRoutes, journeys: []);
    }

    final journeys = _findJourneys(departureNorm, arrivalNorm, allRoutes);
    journeys.sort((a, b) => a.totalDistance.compareTo(b.totalDistance));

    return RouteResult(directRoutes: [], journeys: journeys.take(3).toList());
  }

  static List<Journey> _findJourneys(
      String departure, String arrival, List<BusRoute> allRoutes) {
    final journeys = <Journey>[];
    final seenJourneySignatures = <String>{}; // Track unique journey combinations
    final stopToRoutes = <String, List<BusRoute>>{};
    final stopMap = <String, BusStop>{};

    for (final route in allRoutes) {
      if (route.isSuspended) continue;
      for (final stop in route.stops) {
        final stopNorm = stop.name.toLowerCase();
        stopToRoutes.putIfAbsent(stopNorm, () => []).add(route);
        stopMap.putIfAbsent(stopNorm, () => stop);
      }
    }

    final priorityQueue = <_PathNode>[];
    final visited = <String, _PathNode>{}; // Stop name -> Best PathNode

    final initialStops = stopMap.values.where((s) => s.name.toLowerCase().contains(departure));
    for (final startStop in initialStops) {
      final startNode = _PathNode(startStop, null, null);
      priorityQueue.add(startNode);
      visited[startStop.name.toLowerCase()] = startNode;
    }

    while (priorityQueue.isNotEmpty) {
      priorityQueue.sort(); // Simulate a priority queue
      final currentNode = priorityQueue.removeAt(0);

      if (currentNode.stop.name.toLowerCase().contains(arrival)) {
        final journey = _reconstructJourney(currentNode);
        final signature = _getJourneySignature(journey);

        // Only add if this exact journey hasn't been found before
        if (!seenJourneySignatures.contains(signature)) {
          seenJourneySignatures.add(signature);
          journeys.add(journey);
          if (journeys.length >= 3) return journeys; // Stop if we have enough unique options
        }
        continue;
      }

      if (currentNode.transfers >= 3) continue;

      final routesFromCurrentStop = stopToRoutes[currentNode.stop.name.toLowerCase()] ?? [];
      for (final route in routesFromCurrentStop) {
        final stopIndexOnRoute = route.stops.indexWhere((s) => s.name.toLowerCase() == currentNode.stop.name.toLowerCase());

        // Explore forward
        for (int i = stopIndexOnRoute + 1; i < route.stops.length; i++) {
          _addNodeToQueue(route.stops[i], route, currentNode, visited, priorityQueue);
        }

        // Explore backward
        for (int i = stopIndexOnRoute - 1; i >= 0; i--) {
          _addNodeToQueue(route.stops[i], route, currentNode, visited, priorityQueue);
        }
      }
    }

    return journeys;
  }

  // Generate a unique signature for a journey based on route numbers and transfer stops
  static String _getJourneySignature(Journey journey) {
    final routeNumbers = journey.routes.map((r) => r.lineNumber).join('-');
    final transferStopNames = journey.transferStops.map((s) => s.name.toLowerCase()).join('|');
    return '$routeNumbers:$transferStopNames';
  }

  static void _addNodeToQueue(
    BusStop stop, 
    BusRoute route, 
    _PathNode previousNode, 
    Map<String, _PathNode> visited, 
    List<_PathNode> queue) { // Changed to List for sorting

    final stopNorm = stop.name.toLowerCase();
    final newTransfers = (previousNode.route != null && previousNode.route != route)
        ? previousNode.transfers + 1
        : previousNode.transfers;

    final distance = previousNode.distance + _calculateDistance(previousNode.stop, stop);

    final bestPath = visited[stopNorm];
    final bool shouldVisit = bestPath == null ||
        newTransfers < bestPath.transfers ||
        (newTransfers == bestPath.transfers && distance < bestPath.distance);

    if (shouldVisit) {
      final newNode = _PathNode(stop, route, previousNode, 
          transfers: newTransfers, distance: distance);
      visited[stopNorm] = newNode;
      queue.add(newNode);
    }
  }

  static Journey _reconstructJourney(_PathNode endNode) {
    final path = <_PathNode>[];
    _PathNode? current = endNode;
    while (current != null) {
      path.insert(0, current);
      current = current.previous;
    }

    final routes = <BusRoute>[];
    final transferStops = <BusStop>[];
    
    BusRoute? currentRoute;

    for (int i = 0; i < path.length; i++) {
      final node = path[i];
      if (node.route != null && node.route != currentRoute) {
        if (currentRoute != null) { // This is a true transfer
          transferStops.add(path[i - 1].stop);
        }
        currentRoute = node.route!;
        routes.add(currentRoute);
      }
    }

    return Journey(
      routes: routes,
      transferStops: transferStops,
      totalDistance: endNode.distance,
    );
  }

  static double _calculateDistance(BusStop from, BusStop to) {
    if (from.latitude == 0.0 || from.longitude == 0.0 || to.latitude == 0.0 || to.longitude == 0.0) {
      return 1.0; // Return a default distance if coordinates are missing
    }
    const R = 6371; // Radius of Earth in kilometers
    final lat1 = from.latitude * pi / 180;
    final lon1 = from.longitude * pi / 180;
    final lat2 = to.latitude * pi / 180;
    final lon2 = to.longitude * pi / 180;

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) *
        sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  static List<BusRoute> _findDirectRoutes(
      String departure, String arrival, List<BusRoute> allRoutes) {
    final directRoutes = <BusRoute>[];
    for (final route in allRoutes) {
      if (route.isSuspended) continue;
      final departureIndex = route.stops.indexWhere((s) => s.name.toLowerCase().contains(departure));
      final arrivalIndex = route.stops.indexWhere((s) => s.name.toLowerCase().contains(arrival));

      if (departureIndex != -1 && arrivalIndex != -1) {
        directRoutes.add(route);
      }
    }
    return directRoutes;
  }

  static List<BusStop> getAllStops(List<BusRoute> routes) {
    final allStops = <BusStop>{};
    final seen = <String>{};
    for (final route in routes) {
      if (!route.isSuspended) {
        for (final stop in route.stops) {
          if(seen.add(stop.name)) {
            allStops.add(stop);
          }
        }
      }
    }
    final stopsList = allStops.toList();
    stopsList.sort((a, b) => a.name.compareTo(b.name));
    return stopsList;
  }
}
