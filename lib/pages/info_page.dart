import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildFareCard(),
          const SizedBox(height: 16),
          _buildContactCard(),
        ],
      ),
    );
  }

  Widget _buildFareCard() {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: const Icon(Icons.receipt_long, color: Color(0xFF4CAF50)),
        title: const Text('Grille Tarifaire', style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          _buildFareTable(),
          const Divider(height: 20, indent: 16, endIndent: 16),
          _buildIntercityFares(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Ticket aller simple de la Ligne 17 : 300 FCFA',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFareTable() {
    return DataTable(
      columnSpacing: 16,
      columns: const [
        DataColumn(label: Text('Désignation', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(label: Text('Étudiant', style: TextStyle(fontWeight: FontWeight.bold))), 
        DataColumn(label: Text('Autre', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Ticket à la course')),
          DataCell(Text('200')),
          DataCell(Text('200')),
        ]),
        DataRow(cells: [
          DataCell(Text('Abonnement hebdomadaire')),
          DataCell(Text('1 000')),
          DataCell(Text('2 500')),
        ]),
        DataRow(cells: [
          DataCell(Text('Abonnement mensuel')),
          DataCell(Text('3 000')),
          DataCell(Text('7 000')),
        ]),
        DataRow(cells: [
          DataCell(Text('Abonnement trimestriel')),
          DataCell(Text('-')),
          DataCell(Text('20 000')),
        ]),
        DataRow(cells: [
          DataCell(Text('Abonnement annuel')),
          DataCell(Text('35 000')),
          DataCell(Text('-')),
        ]),
      ],
    );
  }

  Widget _buildIntercityFares() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lignes Intercommunales', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          _buildIntercityFareRow('Ouagadougou - Koubri', '400 FCFA', '18 000 FCFA/mois'),
          _buildIntercityFareRow('Ouagadougou - Ziniaré', '700 FCFA', '15 000 FCFA/mois'),
          _buildIntercityFareRow('Ouagadougou - Pabré', '500 FCFA', '12 000 FCFA/mois'),
        ],
      ),
    );
  }

  Widget _buildIntercityFareRow(String title, String ticketPrice, String subscription) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('Ticket: $ticketPrice - Abonnement: $subscription'),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact & Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildContactRow(Icons.phone, '+226 25355555', 'tel:+22625355555'),
            _buildContactRow(Icons.phone, '+226 52501818', 'https://wa.me/22652501818'),
            _buildContactRow(Icons.email, 'contact@sotraco.bf', 'mailto:contact@sotraco.bf'),
            _buildContactRow(Icons.access_time, 'Lun - Ven : 7h30 - 16h00', null),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, String? url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: url != null ? () => _launchURL(url) : null,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4CAF50)),
            const SizedBox(width: 16),
            Text(text),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Could not launch url
    }
  }
}
