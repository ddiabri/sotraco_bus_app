import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'data/routes_data.dart';
import 'models/bus_route.dart';
import 'pages/info_page.dart';
import 'pages/route_search_page.dart';
import 'widgets/banner_ad_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const CampusRideApp());
}

class CampusRideApp extends StatelessWidget {
  const CampusRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusRide - Itinéraires des bus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'Toutes';
  List<BusRoute> allRoutes = [];

  @override
  void initState() {
    super.initState();
    allRoutes = RoutesData.getAllRoutes();
  }

  List<BusRoute> get filteredRoutes {
    if (selectedCategory == 'Toutes') {
      return allRoutes;
    }
    return allRoutes.where((route) => route.category == selectedCategory).toList();
  }

  List<String> get categories {
    final cats = allRoutes.map((r) => r.category).toSet().toList();
    cats.insert(0, 'Toutes');
    return cats;
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
        title: const Column(
          children: [
            Text(
              'CampusRide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Itinéraires des bus',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RouteSearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
            tooltip: 'Rechercher un itinéraire',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfoPage(),
                ),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'Informations',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category == 'Regular Lines' ? 'Lignes régulières' : category == 'Student Lines' ? 'Lignes étudiantes' : category == 'Intercommunal Lines' ? 'Lignes intercommunales' : 'Toutes'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF4CAF50),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Routes List
          Expanded(
            child: filteredRoutes.isEmpty
                ? const Center(
                    child: Text('Aucun itinéraire disponible'),
                  )
                : ListView.builder(
                    itemCount: filteredRoutes.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final route = filteredRoutes[index];
                      return RouteCard(
                        route: route,
                        categoryColor: getCategoryColor(route.category),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RouteDetailPage(route: route),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
          // Banner Ad at bottom
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  final BusRoute route;
  final Color categoryColor;
  final VoidCallback onTap;

  const RouteCard({
    super.key,
    required this.route,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 2,
      child: InkWell(
        onTap: route.isSuspended ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: route.isSuspended ? 0.5 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Line Number Badge
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: route.isSuspended ? Colors.grey : categoryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      route.lineNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Route Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              route.isSuspended
                                  ? 'SUSPENDU'
                                  : '${route.stops.length} arrêts',
                              style: TextStyle(
                                fontSize: 12,
                                color: route.isSuspended ? Colors.red : Colors.grey[600],
                                fontWeight: route.isSuspended ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!route.isSuspended)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RouteDetailPage extends StatelessWidget {
  final BusRoute route;

  const RouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ligne ${route.lineNumber}'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Route Header
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
              ],
            ),
          ),
          // Stops List
          Expanded(
            child: ListView.builder(
              itemCount: route.stops.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final stop = route.stops[index];
                final isFirst = index == 0;
                final isLast = index == route.stops.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline
                    Column(
                      children: [
                        if (!isFirst)
                          Container(
                            width: 2,
                            height: 20,
                            color: const Color(0xFF4CAF50),
                          ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: isFirst || isLast
                                ? const Color(0xFF4CAF50)
                                : Colors.white,
                            border: Border.all(
                              color: const Color(0xFF4CAF50),
                              width: 3,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 40,
                            color: const Color(0xFF4CAF50),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Stop Name
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
                                fontWeight: isFirst || isLast
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isFirst)
                              Text(
                                'Point de départ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            if (isLast)
                              Text(
                                'Destination',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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
