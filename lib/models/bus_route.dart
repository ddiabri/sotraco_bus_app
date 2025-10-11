class BusStop {
  final String name;
  final double latitude;
  final double longitude;

  BusStop({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class BusRoute {
  final String lineNumber;
  final String name;
  final String category;
  final List<BusStop> stops;
  final bool isSuspended;

  BusRoute({
    required this.lineNumber,
    required this.name,
    required this.category,
    required this.stops,
    this.isSuspended = false,
  });
}
