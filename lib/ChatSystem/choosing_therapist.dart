import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/ChatSystem/sendrequest_Screen.dart';
import 'package:kineticare/components/initials_avatar.dart';

class ChooseTherapistScreen extends StatefulWidget {
  final ValueChanged<String> onTherapistSelected;

  const ChooseTherapistScreen({
    Key? key,
    required this.onTherapistSelected,
  }) : super(key: key);

  @override
  _ChooseTherapistScreenState createState() => _ChooseTherapistScreenState();
}

class _ChooseTherapistScreenState extends State<ChooseTherapistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _therapists = [];
  List<Map<String, dynamic>> _filteredTherapists = [];
  String? _selectedTherapistId;

  @override
  void initState() {
    super.initState();
    _fetchTherapists();
    _searchController.addListener(() => _filterTherapists(_searchController.text));
  }

  Future<void> _fetchTherapists() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'therapist')
        .get();

    if (mounted) {
      setState(() {
        _therapists = querySnapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        }).toList();
        _filteredTherapists = _therapists;
      });
    }
  }

  void _filterTherapists(String searchText) {
    String searchQuery = searchText.toLowerCase();
    setState(() {
      _filteredTherapists = _therapists
          .where((therapist) => therapist['firstName']?.toLowerCase().contains(searchQuery) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Choose a Physical Therapist',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Find a PT that suits your needs',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search Therapists',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTherapists.length,
              itemBuilder: (context, index) {
                var therapist = _filteredTherapists[index];
                bool isSelected = therapist['id'] == _selectedTherapistId;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTherapistId = therapist['id'];
                    });
                    if (_selectedTherapistId != null) {
                      widget.onTherapistSelected(_selectedTherapistId!);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: InitialsAvatar(
                        firstName: therapist['firstName'] ?? '',
                        radius: 35,
                      ),
                      title: Text(therapist['firstName'] ?? 'Unknown'),
                      subtitle: Text('License: ${therapist['licenseNumber'] ?? 'N/A'}'),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedTherapistId != null)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RequestScreen(
                      therapistId: _selectedTherapistId!,
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}