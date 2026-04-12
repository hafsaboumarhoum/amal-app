import 'package:flutter/material.dart';
import '../services/checklist_service.dart';
import 'checklist_result_screen.dart';

class ChecklistScreen extends StatefulWidget {
  final String language;

  const ChecklistScreen({super.key, required this.language});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final Map<int, bool> _answers = {};

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.language == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFFF2EAE0),
      appBar: AppBar(
        title: Text(
          isArabic ? 'قائمة العلامات المبكرة' : 'Early Signs Checklist',
        ),
        backgroundColor: const Color(0xFFB4D3D9),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<ChecklistItem>>(
        future: ChecklistService.loadItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFBDA6CE)));
          }
          final items = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CheckboxListTile(
                        value: _answers[index] ?? false,
                        onChanged: (val) {
                          setState(() {
                            _answers[index] = val ?? false;
                          });
                        },
                        title: Text(
                          isArabic ? item.signArabic : item.signEnglish,
                          style: const TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(
                          isArabic
                              ? ChecklistService.ageGroupArabic[item.ageGroup]!
                              : item.ageGroup,
                          style: const TextStyle(
                            color: Color(0xFFBDA6CE),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        activeColor: const Color(0xFFBDA6CE),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    final checkedCount =
                        _answers.values.where((v) => v).length;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChecklistResultScreen(
                          checkedCount: checkedCount,
                          totalCount: items.length,
                          language: widget.language,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBDA6CE),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isArabic ? 'عرض النتائج' : 'See Results',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}