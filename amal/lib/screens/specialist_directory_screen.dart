import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SpecialistDirectoryScreen extends StatefulWidget {
  final String language;

  const SpecialistDirectoryScreen({super.key, required this.language});

  @override
  State<SpecialistDirectoryScreen> createState() =>
      _SpecialistDirectoryScreenState();
}

class _SpecialistDirectoryScreenState
    extends State<SpecialistDirectoryScreen> {
  String _selectedCity = 'All';
  String _selectedType = 'All';

  double? _userLat;
  double? _userLng;

  final _cities = [
    {'en': 'All', 'ar': 'الكل'},
    {'en': 'Casablanca', 'ar': 'الدار البيضاء'},
    {'en': 'Rabat', 'ar': 'الرباط'},
    {'en': 'Fes', 'ar': 'فاس'},
    {'en': 'Marrakech', 'ar': 'مراكش'},
    {'en': 'Tangier', 'ar': 'طنجة'},
    {'en': 'Agadir', 'ar': 'أكادير'},
    {'en': 'Meknes', 'ar': 'مكناس'},
    {'en': 'Oujda', 'ar': 'وجدة'},
  ];

  final _types = [
    {'en': 'All', 'ar': 'الكل'},
    {'en': 'Speech Therapy', 'ar': 'علاج النطق'},
    {'en': 'ABA Therapy', 'ar': 'تحليل السلوك التطبيقي'},
    {'en': 'Occupational Therapy', 'ar': 'العلاج الوظيفي'},
    {'en': 'Diagnosis', 'ar': 'تشخيص'},
    {'en': 'Association', 'ar': 'جمعية'},
    {'en': 'Hospital', 'ar': 'مستشفى'},
  ];

  final _typeAr = {
    'Speech Therapy': 'علاج النطق',
    'ABA Therapy': 'تحليل السلوك التطبيقي',
    'Occupational Therapy': 'العلاج الوظيفي',
    'Diagnosis': 'تشخيص',
    'Association': 'جمعية',
    'Hospital': 'مستشفى',
  };

  final _cityAr = {
    'Casablanca': 'الدار البيضاء',
    'Rabat': 'الرباط',
    'Fes': 'فاس',
    'Marrakech': 'مراكش',
    'Tangier': 'طنجة',
    'Agadir': 'أكادير',
    'Meknes': 'مكناس',
    'Oujda': 'وجدة',
  };

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLat = position.latitude;
      _userLng = position.longitude;
    });
  }

  double _distanceTo(double lat, double lng) {
    if (_userLat == null) return double.infinity;

    return Geolocator.distanceBetween(
          _userLat!,
          _userLng!,
          lat,
          lng,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';

    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('specialists');

    if (_selectedCity != 'All') {
      query = query.where('city', isEqualTo: _selectedCity);
    }

    if (_selectedType != 'All') {
      query = query.where('specialty', isEqualTo: _selectedType);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title:
            Text(isArabic ? 'دليل المختصين' : 'Specialist Directory'),
        backgroundColor: const Color(0xFFD7897F),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // TYPE FILTER
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _types.map((type) {
                final selected = _selectedType == type['en'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                        isArabic ? type['ar']! : type['en']!),
                    selected: selected,
                    selectedColor: const Color(0xFFD7897F),
                    labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black),
                    onSelected: (_) => setState(
                        () => _selectedType = type['en']!),
                  ),
                );
              }).toList(),
            ),
          ),

          // CITY DROPDOWN
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              items: _cities.map((c) {
                return DropdownMenuItem<String>(
                  value: c['en'],
                  child: Text(
                      isArabic ? c['ar']! : c['en']!),
                );
              }).toList(),
              onChanged: (val) =>
                  setState(() => _selectedCity = val!),
            ),
          ),

          // LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      isArabic
                          ? 'لا توجد نتائج'
                          : 'No results found',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;

                    final type = data['specialty'] ?? '';
                    final city = data['city'] ?? '';
                    final lat = data['latitude'] ?? 0.0;
                    final lng = data['longitude'] ?? 0.0;

                    final distance = _distanceTo(lat, lng);
                    final distText =
                        distance == double.infinity
                            ? ''
                            : '${distance.toStringAsFixed(1)} km';

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.all(16),

                        title: Text(
                          isArabic
                              ? data['title_ar']
                              : data['title_en'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),

                            Text(
                              isArabic
                                  ? '${_typeAr[type] ?? type} • ${data['specialty'] ?? ''}'
                                  : '$type • ${data['specialty'] ?? ''}',
                            ),

                            Text(
                              isArabic
                                  ? '${_cityAr[city] ?? city} • $distText'
                                  : '$city • $distText',
                            ),
                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.phone,
                              color: Color(0xFFD7897F)),
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