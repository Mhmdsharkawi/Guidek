class Subject {
  final String name;
  final List<Subject> children;
  bool isChecked;

  Subject({required this.name, this.children = const [], this.isChecked = false});
}

class SubjectTree {
  static final List<Subject> _subjects = [
    Subject(
      name: 'Math',
      children: [
        Subject(name: 'Algebra'),
        Subject(name: 'Geometry'),
      ],
    ),
    Subject(
      name: 'Science',
      children: [
        Subject(name: 'Physics'),
        Subject(name: 'Chemistry'),
      ],
    ),
    Subject(
      name: 'History',
      children: [
        Subject(name: 'World History'),
        Subject(name: 'American History'),
      ],
    ),
    Subject(
      name: 'Language Arts',
      children: [
        Subject(name: 'Literature'),
        Subject(name: 'Grammar'),
      ],
    ),
  ];

  static List<Subject> getAllSubjects() {
    return _subjects.expand((subject) => _flattenTree(subject)).toList();
  }

  static Iterable<Subject> _flattenTree(Subject subject) sync* {
    yield subject;
    for (final child in subject.children) {
      yield* _flattenTree(child);
    }
  }
}
