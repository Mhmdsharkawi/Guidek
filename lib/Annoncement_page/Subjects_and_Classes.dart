import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tree.dart';

class SubjectsAndClasses extends StatefulWidget {
  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsAndClasses> {
  final TextEditingController searchController = TextEditingController();
  List<Subject> subjects = SubjectTree.getAllSubjects();
  List<Subject> filteredSubjects = [];

  @override
  void initState() {
    super.initState();
    filteredSubjects = subjects;
  }

  void _filterSubjects(String query) {
    final results = subjects.where((subject) {
      final subjectLower = subject.name.toLowerCase();
      final searchLower = query.toLowerCase();
      return subjectLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredSubjects = results;
    });
  }

  void _getNextSubjects() {
    final checkedSubjects = subjects.where((subject) => subject.isChecked).toList();
    final nextSubjects = <Subject>[];

    for (final subject in checkedSubjects) {
      nextSubjects.addAll(subject.children);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: nextSubjects.isNotEmpty
              ? Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: nextSubjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(nextSubjects[index].name),
                );
              },
            ),
          )
              : Text('There are no following subjects for the selected ones.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF318c3c),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Text(
              'Subjects',
              style: GoogleFonts.notoSans(fontWeight: FontWeight.normal, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/guidek-bg.jpg.svg',
              fit: BoxFit.fill,
              color: const Color.fromARGB(100, 220, 220, 220),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search subjects',
                  ),
                  onChanged: _filterSubjects,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = filteredSubjects[index];
                      return ListTile(
                        title: Text(subject.name),
                        leading: Checkbox(
                          value: subject.isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              subject.isChecked = value!;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 32.0, right: 32.0),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF318c3c),
          onPressed: _getNextSubjects,
          label: const Text('Get Next Subjects', style: TextStyle(color: Colors.black)),
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
    );
  }
}
