import 'dart:convert';

class Subject {
  final String name;
  final List<Subject> children;
  bool isChecked;

  Subject({required this.name, this.children = const [], this.isChecked = false});

  factory Subject.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['children'] as List;
    List<Subject> childrenList = childrenFromJson.map((child) => Subject.fromJson(child)).toList();

    return Subject(
      name: json['name'],
      children: childrenList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}

class SubjectTree {
  static List<Subject> subjects = [];

  static void loadFromJson(String jsonString) {
    final jsonResponse = json.decode(jsonString);
    subjects = (jsonResponse['subjects'] as List).map((subject) => Subject.fromJson(subject)).toList();
  }

  static List<Subject> getAllSubjects() {
    return subjects.expand((subject) => _flattenTree(subject)).toList();
  }

  static Iterable<Subject> _flattenTree(Subject subject) sync* {
    yield subject;
    for (final child in subject.children) {
      yield* _flattenTree(child);
    }
  }
}
