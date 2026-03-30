import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialistDirectoryScreen extends StatefulWidget {
  final String language;
  const SpecialistDirectoryScreen({super.key, required this.language});
@override
  State<SpecialistDirectoryScreen> createState() => _SpecialistDirectoryScreenState();
}

class _SpecialistDirectoryScreenState extends State<SpecialistDirectoryScreen> {
  String _selectedCity = 'All';
  String _selectedType = 'All';

  final _cities = ['All', 'Casablanca', 'Rabat', 'Fes', 'Marrakech', 'Tangier', 'Agadir', 'Meknes', 'Oujda'];
  final _types = ['All', 'Speech Therapy', 'ABA Therapy', 'Occupational Therapy', 'Diagnosis'];

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('specialists');
    if (_selectedCity != 'All') {
      query = query.where('city', isEqualTo: _selectedCity);
    }
    if (_selectedType != 'All') {
      query = query.where('specialty', isEqualTo: _selectedType);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'دليل المختصين' : 'Specialist Directory'),
        backgroundColor: const Color(0xFFD7897F),
foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Type filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _types.map((type) {
                final selected = _selectedType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
label: Text(type),
                    selected: selected,
                    selectedColor: const Color(0xFFD7897F),
                    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                    onSelected: (_) => setState(() => _selectedType = type),
                  ),
                );
              }).toList(),
            ),
          ),
          // City dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
value: _selectedCity,
              isExpanded: true,
              items: _cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCity = val!),
            ),
          ),
          // List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      isArabic ? 'لا توجد نتائج' : 'No results found',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          data['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('${data['type']} • ${data['specialty']}'),
                            Text('${data['city']} • ${data['address']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.phone, color: Color(0xFFD7897F)),
                          onPressed: () async {
                            final phone = data['phone'] ?? '';
                            final uri = Uri.parse('tel:$phone');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
