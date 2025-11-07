import 'package:flutter/material.dart';
import '../models/bus_route.dart';
import '../services/route_finder.dart';
import '../data/routes_data.dart';
import '../widgets/banner_ad_widget.dart';

class RouteSearchPage extends StatefulWidget {
  const RouteSearchPage({super.key});

  @override
  State<RouteSearchPage> createState() => _RouteSearchPageState();
}

class _RouteSearchPageState extends State<RouteSearchPage> {
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();

  List<BusStop> allStops = [];
  List<BusStop> filteredDepartureStops = [];
  List<BusStop> filteredArrivalStops = [];
  RouteResult? searchResult;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    allStops = RouteFinder.getAllStops(RoutesData.getAllRoutes());

    departureController.addListener(() {
      setState(() {
        filteredDepartureStops = _filterStops(departureController.text);
      });
    });

    arrivalController.addListener(() {
      setState(() {
        filteredArrivalStops = _filterStops(arrivalController.text);
      });
    });
  }

  List<BusStop> _filterStops(String query) {
    if (query.isEmpty) return [];

    final lowerCaseQuery = query.toLowerCase();

    // Prioritize stops that start with the query
    final startsWith = allStops
        .where((stop) => stop.name.toLowerCase().startsWith(lowerCaseQuery))
        .toList();

    // Then, include stops that contain the query (and are not already in the list)
    final contains = allStops
        .where((stop) =>
            stop.name.toLowerCase().contains(lowerCaseQuery) &&
            !startsWith.contains(stop))
        .toList();

    // Combine the lists and take the top 5
    return (startsWith + contains).take(5).toList();
  }

  void _searchRoutes() {
    if (departureController.text.isEmpty || arrivalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer les points de départ et d\'arrivée'),
        ),
      );
      return;
    }

    setState(() {
      isSearching = true;
      searchResult = RouteFinder.findRoutes(
        departure: departureController.text,
        arrival: arrivalController.text,
        allRoutes: RoutesData.getAllRoutes(),
      );
      isSearching = false;
      filteredDepartureStops = [];
      filteredArrivalStops = [];
    });
  }

  void _swapPoints() {
    final temp = departureController.text;
    departureController.text = arrivalController.text;
    arrivalController.text = temp;
  }

  @override
  void dispose() {
    departureController.dispose();
    arrivalController.dispose();
    super.dispose();
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Regular Lines':
        return Colors.blue;
      case 'Student Lines':
        return Colors.orange;
      case 'Intercommunal Lines':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trouver un itinéraire'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Form
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                // Departure Field
                _buildAutocompleteField(
                  controller: departureController,
                  label: 'De (Départ)',
                  icon: Icons.trip_origin,
                  suggestions: filteredDepartureStops,
                ),
                const SizedBox(height: 8),
                // Swap Button
                Center(
                  child: IconButton(
                    onPressed: _swapPoints,
                    icon: const Icon(Icons.swap_vert),
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 8),
                // Arrival Field
                _buildAutocompleteField(
                  controller: arrivalController,
                  label: 'À (Arrivée)',
                  icon: Icons.location_on,
                  suggestions: filteredArrivalStops,
                ),
                const SizedBox(height: 16),
                // Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSearching ? null : _searchRoutes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isSearching
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Rechercher',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Results
          Expanded(
            child: searchResult == null
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Entrez les points de départ et d\'arrivée\npour trouver les itinéraires disponibles',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : _buildResults(),
          ),
          // Banner Ad at bottom
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildAutocompleteField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<BusStop> suggestions,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        if (suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  title: Text(suggestions[index].name),
                  onTap: () {
                    controller.text = suggestions[index].name;
                    setState(() {
                      if (controller == departureController) {
                        filteredDepartureStops = [];
                      } else {
                        filteredArrivalStops = [];
                      }
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildResults() {
    final hasDirectRoutes = searchResult!.directRoutes.isNotEmpty;
    final hasJourneys = searchResult!.journeys.isNotEmpty;
    final hasNearbyDepartures = searchResult!.nearbyDepartures.isNotEmpty;
    final hasNearbyArrivals = searchResult!.nearbyArrivals.isNotEmpty;

    if (!hasDirectRoutes && !hasJourneys) {
      return Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.orange),
                SizedBox(height: 16),
                Text(
                  'Aucun itinéraire trouvé',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Essayez d\'ajuster vos termes de recherche',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (hasNearbyDepartures || hasNearbyArrivals) ...[
              const SizedBox(height: 24),
              _buildNearbyStopsSection(),
            ],
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (hasDirectRoutes) ...[
          _buildSectionHeader('Itinéraires directs', searchResult!.directRoutes.length),
          const SizedBox(height: 8),
          ...searchResult!.directRoutes.map((route) => _buildDirectRouteCard(route)),
          const SizedBox(height: 16),
        ],
        if (hasJourneys) ...[
          _buildSectionHeader('Itinéraires avec correspondances', searchResult!.journeys.length),
          const SizedBox(height: 8),
          ...searchResult!.journeys.map((journey) => _buildJourneyCard(journey)),
        ],
        if (hasNearbyDepartures || hasNearbyArrivals) ...[
          const SizedBox(height: 16),
          _buildNearbyStopsSection(),
        ],
      ],
    );
  }

  Widget _buildNearbyStopsSection() {
    final hasNearbyDepartures = searchResult!.nearbyDepartures.isNotEmpty;
    final hasNearbyArrivals = searchResult!.nearbyArrivals.isNotEmpty;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_walk, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Arrêts à proximité',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Ces arrêts sont proches de votre recherche et pourraient offrir de meilleurs itinéraires :',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[800],
              ),
            ),
            if (hasNearbyDepartures) ...[
              const SizedBox(height: 12),
              Text(
                'Près du départ :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 4),
              ...searchResult!.nearbyDepartures.map((suggestion) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.place, size: 16, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestion.stop.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        '(${(suggestion.distance * 1000).toStringAsFixed(0)}m)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (hasNearbyArrivals) ...[
              const SizedBox(height: 12),
              Text(
                'Près de l\'arrivée :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                ),
              ),
              const SizedBox(height: 4),
              ...searchResult!.nearbyArrivals.map((suggestion) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.place, size: 16, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          suggestion.stop.name,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Text(
                        '(${(suggestion.distance * 1000).toStringAsFixed(0)}m)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Icon(
          title.contains('directs') ? Icons.directions_bus : Icons.transfer_within_a_station,
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDirectRouteCard(BusRoute route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: getCategoryColor(route.category),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              route.lineNumber,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(route.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${route.stops.length} arrêts'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RouteDetailPage(
                route: route,
                departure: departureController.text,
                arrival: arrivalController.text,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJourneyCard(Journey journey) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JourneyDetailPage(journey: journey),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Journey summary header with distance
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.route, color: Colors.green[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${journey.transferStops.length} ${journey.transferStops.length == 1 ? "correspondance" : "correspondances"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                        Text(
                          'Distance totale : ${journey.totalDistance.toStringAsFixed(2)} km',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Route details
            ...List.generate(journey.routes.length, (index) {
              final route = journey.routes[index];
              final isFirst = index == 0;
              final isLast = index == journey.routes.length - 1;

              String from = isFirst ? journey.departureStop.name : journey.transferStops[index - 1].name;
              String to = isLast ? journey.arrivalStop.name : journey.transferStops[index].name;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: getCategoryColor(route.category),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              route.lineNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'De : $from',
                          ),
                          const Spacer(),
                          if (!isLast)
                            Row(
                              children: [
                                const Icon(Icons.transfer_within_a_station, color: Colors.orange, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Correspondance à : $to',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          if (isLast)
                            Text(
                              'À : $to',
                              style: const TextStyle(fontWeight: FontWeight.bold)
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            // Tap indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Voir les détails',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.green[700]),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class RouteDetailPage extends StatelessWidget {
  final BusRoute route;
  final String? departure;
  final String? arrival;

  const RouteDetailPage({
    super.key,
    required this.route,
    this.departure,
    this.arrival,
  });

  @override
  Widget build(BuildContext context) {
    final departureIndex = route.stops.indexWhere((s) => s.name.toLowerCase().contains(departure!.toLowerCase()));
    final arrivalIndex = route.stops.indexWhere((s) => s.name.toLowerCase().contains(arrival!.toLowerCase()));

    // Only show the portion of the route between departure and arrival
    final isReversed = departureIndex > arrivalIndex;
    final int firstIdx = isReversed ? arrivalIndex : departureIndex;
    final int lastIdx = isReversed ? departureIndex : arrivalIndex;
    var displayedStops = route.stops.sublist(firstIdx, lastIdx + 1);
    if (isReversed) {
      displayedStops = displayedStops.reversed.toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Ligne ${route.lineNumber}'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        route.lineNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        route.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  route.category == 'Regular Lines' ? 'Ligne régulière' : route.category == 'Student Lines' ? 'Ligne étudiante' : route.category == 'Intercommunal Lines' ? 'Ligne intercommunale' : route.category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${displayedStops.length} arrêts sur votre trajet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedStops.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final stop = displayedStops[index];
                final isDeparture = departure != null &&
                    stop.name.toLowerCase().contains(departure!.toLowerCase());
                final isArrival = arrival != null &&
                    stop.name.toLowerCase().contains(arrival!.toLowerCase());

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        if (index != 0)
                          Container(
                            width: 2,
                            height: 20,
                            color: const Color(0xFF4CAF50),
                          ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isDeparture || isArrival
                                ? Colors.orange
                                : Colors.white,
                            border: Border.all(
                              color: const Color(0xFF4CAF50),
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (index != displayedStops.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: const Color(0xFF4CAF50),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stop.name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isDeparture || isArrival
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isDeparture)
                              Text(
                                'Votre départ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            if (isArrival)
                              Text(
                                'Votre arrivée',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class JourneyDetailPage extends StatelessWidget {
  final Journey journey;

  const JourneyDetailPage({
    super.key,
    required this.journey,
  });

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Regular Lines':
        return Colors.blue;
      case 'Student Lines':
        return Colors.orange;
      case 'Intercommunal Lines':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinéraire avec correspondance'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Journey summary header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_bus, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${journey.routes.length} bus - ${journey.transferStops.length} ${journey.transferStops.length == 1 ? "correspondance" : "correspondances"}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Distance totale : ${journey.totalDistance.toStringAsFixed(2)} km',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Route segments with stops
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: journey.routes.length,
              itemBuilder: (context, routeIndex) {
                final route = journey.routes[routeIndex];
                final isFirst = routeIndex == 0;
                final isLast = routeIndex == journey.routes.length - 1;

                // Determine start and end stops for this route segment
                final startStop = isFirst
                    ? journey.departureStop
                    : journey.transferStops[routeIndex - 1];
                final endStop = isLast
                    ? journey.arrivalStop
                    : journey.transferStops[routeIndex];

                // Find indices in the route's stop list
                final startIndex = route.stops.indexWhere(
                  (s) => s.name.toLowerCase() == startStop.name.toLowerCase()
                );
                final endIndex = route.stops.indexWhere(
                  (s) => s.name.toLowerCase() == endStop.name.toLowerCase()
                );

                // Get stops in correct order
                final isReversed = startIndex > endIndex;
                final int firstIdx = isReversed ? endIndex : startIndex;
                final int lastIdx = isReversed ? startIndex : endIndex;
                var segmentStops = route.stops.sublist(firstIdx, lastIdx + 1);
                if (isReversed) {
                  segmentStops = segmentStops.reversed.toList();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Route segment header
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: getCategoryColor(route.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: getCategoryColor(route.category),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                route.lineNumber,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  route.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${segmentStops.length} arrêts',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Stops list for this segment
                    ...segmentStops.asMap().entries.map((entry) {
                      final stopIndex = entry.key;
                      final stop = entry.value;
                      final isSegmentLast = stopIndex == segmentStops.length - 1;

                      final isDeparture = stop.name.toLowerCase() == journey.departureStop.name.toLowerCase();
                      final isArrival = stop.name.toLowerCase() == journey.arrivalStop.name.toLowerCase();
                      final isTransfer = journey.transferStops.any(
                        (t) => t.name.toLowerCase() == stop.name.toLowerCase()
                      );

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 20),
                          Column(
                            children: [
                              if (stopIndex != 0)
                                Container(
                                  width: 2,
                                  height: 20,
                                  color: getCategoryColor(route.category),
                                ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: (isDeparture || isArrival || isTransfer)
                                      ? Colors.orange
                                      : Colors.white,
                                  border: Border.all(
                                    color: getCategoryColor(route.category),
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (!isSegmentLast)
                                Container(
                                  width: 2,
                                  height: 40,
                                  color: getCategoryColor(route.category),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop.name,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: (isDeparture || isArrival || isTransfer)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  if (isDeparture)
                                    Text(
                                      'Départ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  if (isTransfer)
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.transfer_within_a_station,
                                          size: 16,
                                          color: Colors.orange[800],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Correspondance',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.orange[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (isArrival)
                                    Text(
                                      'Arrivée',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    if (!isLast)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            Icon(Icons.sync_alt, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Changement de bus',
                              style: TextStyle(
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
