import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class AllTipsScreen extends StatefulWidget {
  final String language;
  const AllTipsScreen({super.key, required this.language});

  @override
  State<AllTipsScreen> createState() => _AllTipsScreenState();
}

class _AllTipsScreenState extends State<AllTipsScreen> {
  List<dynamic> _allTips = [];
  String _filterCategory = 'All';
  final _categories = ['All', 'Communication', 'Motor Skills', 'Social', 'Sensory'];

  @override
void initState() {
    super.initState();
    _loadTips();
  }

  Future<void> _loadTips() async {
    final jsonStr = await rootBundle.loadString('assets/data/daily_tips.json');
    setState(() => _allTips = json.decode(jsonStr));
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';
    final filtered = _filterCategory == 'All'
      ? _allTips
      : _allTips.where((t) => t['category'] == _filterCategory).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFEDE8D0),
      appBar: AppBar(
        title: Text(isArabic ? 'جميع النصائح' : 'All Tips'),
        backgroundColor: const Color(0xFFF9B95C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
padding: const EdgeInsets.all(12),
            child: Row(
              children: _categories.map((cat) {
                final selected = _filterCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: const Color(0xFFF9B95C),
                    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                    onSelected: (_) => setState(() => _filterCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final tip = filtered[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      isArabic ? tip['tip_arabic'] : tip['tip_english'],
                      style: const TextStyle(fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(tip['category'], style: const TextStyle(color: Color(0xFFF9B95C))),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
),
    );
  }
}
