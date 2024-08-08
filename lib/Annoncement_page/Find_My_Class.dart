import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FindMyClassPage extends StatefulWidget {
  const FindMyClassPage({super.key});

  @override
  _FindMyClassPageState createState() => _FindMyClassPageState();
}

class _FindMyClassPageState extends State<FindMyClassPage> {
  List<String> floors = ['Ground Floor', '1st Floor', '2nd Floor', '3rd Floor'];
  Map<String, List<String>> rooms = {
    'Ground Floor': ['Room 001', 'Room 002'],
    '1st Floor': ['Room 101', 'Room 102'],
    '2nd Floor': ['Room 201', 'Room 202'],
    '3rd Floor': ['Room 301', 'Room 302']
  };
  String? selectedFloor;
  String? selectedRoom;
  bool isRoot = true;
  List<String> searchResults = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void handleSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    List<String> results = [];
    floors.forEach((floor) {
      if (floor.toLowerCase().contains(query.toLowerCase())) {
        results.add(floor);
      }
      rooms[floor]?.forEach((room) {
        if (room.toLowerCase().contains(query.toLowerCase())) {
          results.add(room);
        }
      });
    });

    setState(() {
      searchResults = results;
    });
  }

  void handleSelection(String item) {
    if (floors.contains(item)) {
      setState(() {
        selectedFloor = item;
        selectedRoom = null;
        isRoot = false;
      });
    } else {
      setState(() {
        selectedRoom = item;
      });
    }
  }

  void handlePrev() {
    setState(() {
      if (selectedRoom != null) {
        selectedRoom = null;
      } else {
        selectedFloor = null;
        isRoot = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));

    List<String> displayList = [];
    if (searchResults.isNotEmpty) {
      displayList = searchResults;
    } else if (isRoot) {
      displayList = floors;
    } else if (selectedFloor != null) {
      displayList = rooms[selectedFloor]!;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF318c3c),
        title: Text(
          'Find My Class',
          style: TextStyle(
            fontFamily: 'Acumin Variable Concept',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: isRoot
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
      body: Container(
        color: Color(0xFFDCF5DC),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 12,
                color: Color(0xFFfdcd90),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 12,
                    color: Color(0xFFfdcd90),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: handleSearch,
                      decoration: InputDecoration(
                        hintText: 'Search by hall number, floor, etc.',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(displayList[index]),
                          onTap: () => handleSelection(displayList[index]),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!isRoot || searchResults.isEmpty)
                          ElevatedButton(
                            onPressed: (isRoot || searchResults.isNotEmpty)
                                ? null
                                : handlePrev,
                            child: Text('< Prev'),
                          ),
                        if (!isRoot && searchResults.isEmpty)
                          ElevatedButton(
                            onPressed: (selectedFloor == null && searchResults.isEmpty)
                                ? null
                                : () {
                              setState(() {
                                isRoot = false;
                              });
                            },
                            child: Text('Next >'),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (selectedRoom != null)
                          ? () {
                        // Handle get directions
                      }
                          : null,
                      child: Text('Get Directions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
