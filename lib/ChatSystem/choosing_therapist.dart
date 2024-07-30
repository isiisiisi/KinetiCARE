import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kineticare/components/app_images.dart';
import 'package:kineticare/components/initials_avatar.dart';
import 'package:kineticare/components/my_backbutton.dart';
import 'package:kineticare/components/patient_components/patient_navbar.dart';
import 'package:kineticare/roles/patient/therapist_information.dart';

class ChooseTherapistScreen extends StatefulWidget {
  final ValueChanged<String> onTherapistSelected;

  const ChooseTherapistScreen({
    super.key,
    required this.onTherapistSelected,
  });

  @override
  _ChooseTherapistScreenState createState() => _ChooseTherapistScreenState();
}

class _ChooseTherapistScreenState extends State<ChooseTherapistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _therapists = [];
  List<Map<String, dynamic>> _filteredTherapists = [];
  String? _selectedTherapistId;
  bool _noResultsFound = false;

  @override
  void initState() {
    super.initState();
    _fetchTherapists();
    _searchController
        .addListener(() => _filterTherapists(_searchController.text));
  }

  Future<void> _fetchTherapists() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'therapist')
        .get();

    if (mounted) {
      setState(() {
        _therapists = querySnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
        _filteredTherapists = _therapists;
      });
    }
  }

  void _filterTherapists(String searchText) {
    String searchQuery = searchText.toLowerCase();
    setState(() {
      _filteredTherapists = _therapists
          .where((therapist) =>
              therapist['firstName']?.toLowerCase().contains(searchQuery) ??
              false)
          .toList();

      _noResultsFound = _filteredTherapists.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyBackButtonRow(
                buttonText: 'Physical Therapists',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientNavBar()),
                  );
                },
                space: 35,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Image.asset(AppImages.search),
                  hintText: 'Search for therapists',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Search Results:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
              Expanded(
                child: _noResultsFound
                    ? const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF707070),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredTherapists.length,
                        itemBuilder: (context, index) {
                          var therapist = _filteredTherapists[index];
                          bool isSelected =
                              therapist['id'] == _selectedTherapistId;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTherapistId = therapist['id'];
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TherapistInformation(
                                    therapist: therapist,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Container(
                                width: 336,
                                height: 140,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFC3C3C3)
                                      : const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0xFF333333),
                                      blurRadius: 4.0,
                                      offset: Offset(0.0, 0.55),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 10, bottom: 8),
                                      child: InitialsAvatar(
                                        firstName:
                                            therapist['firstName'] ?? '',
                                        radius: 50,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                            '${therapist['firstName'] ?? ''} ${therapist['lastName'] ?? ''}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF333333),
                                            )),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${therapist['specialization'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF707070),
                                                )),
                                            Text(
                                                'Rating: ${therapist['rating']?.toStringAsFixed(1) ?? 'N/A'}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF707070),
                                                )),
                                            Text(
                                                'Price Rate: ${therapist['priceRate'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF707070),
                                                )),
                                            Row(
                                              children: [
                                                Image.asset(AppImages.loction),
                                                const SizedBox(width: 4),
                                                Text(
                                                    '${therapist['location'] ?? 'N/A'}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xFF707070),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                        isThreeLine: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
