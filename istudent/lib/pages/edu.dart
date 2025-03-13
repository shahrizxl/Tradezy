import 'package:flutter/material.dart';
import 'package:istudent/pages/bottomnav.dart';
import 'package:istudent/pages/notes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase anon key
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const BottomNav(),
    );
  }
}

class EduNavPage extends StatefulWidget {
  const EduNavPage({super.key});

  @override
  _EduNavPageState createState() => _EduNavPageState();
}

class _EduNavPageState extends State<EduNavPage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [const EducationContent(), const NotesPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Education', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Make Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
        ],
      ),
    );
  }
}

class EducationContent extends StatefulWidget {
  const EducationContent({super.key});

  @override
  _EducationContentState createState() => _EducationContentState();
}

class _EducationContentState extends State<EducationContent> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _schedule = [];
  List<Map<String, dynamic>> _subjects = [];

  final _subjectController = TextEditingController();
  final _difficultyController = TextEditingController(text: 'Medium');
  DateTime? _examDate;

  final List<String> _difficultyLevels = ['Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _difficultyController.dispose();
    super.dispose();
  }

  Future<void> _fetchSubjects() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to view subjects.');
      }

      final response = await supabase
          .from('subjects')
          .select()
          .eq('user_id', user.id)
          .order('exam_date', ascending: true);

      setState(() {
        _subjects = response as List<Map<String, dynamic>>;
      });
      print('Fetched subjects: $_subjects');
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to fetch subjects: $error';
      });
      print('Error details: $error');
    }
  }

  void _addSubject() {
    if (!_formKey.currentState!.validate() || _examDate == null) {
      setState(() {
        _errorMessage = _examDate == null ? 'Please select an exam date' : null;
      });
      return;
    }

    final subject = {
      'subject_name': _subjectController.text.trim(),
      'difficulty': _difficultyController.text,
      'exam_date': DateFormat('yyyy-MM-dd').format(_examDate!),
    };

    setState(() {
      _subjects.add(subject);
      _subjectController.clear();
      _difficultyController.text = 'Medium';
      _examDate = null;
      _errorMessage = null;
    });
    print('Added subject locally: $subject');
  }

  Future<void> _deleteSubject(Map<String, dynamic> subject) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to delete subjects.');
      }

      await supabase
          .from('subjects')
          .delete()
          .eq('user_id', user.id)
          .eq('subject_name', subject['subject_name'])
          .eq('exam_date', subject['exam_date']);

      setState(() {
        _subjects.remove(subject);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Subject deleted successfully!')),
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to delete subject: $error';
      });
      print('Error details: $error');
    }
  }

  List<Map<String, dynamic>> _generateStudySchedule() {
    List<Map<String, dynamic>> schedule = [];
    DateTime now = DateTime.now();
    Map<String, List<Map<String, dynamic>>> dailySchedule = {};

    for (var subject in _subjects) {
      DateTime examDate = DateTime.parse(subject['exam_date']);
      int daysUntilExam = examDate.difference(now).inDays;

      if (daysUntilExam < 7) {
        setState(() {
          _errorMessage = 'Exam date for ${subject['subject_name']} must be at least 7 days from today.';
        });
        return [];
      }

      int dailyHours;
      switch (subject['difficulty']) {
        case 'Easy':
          dailyHours = 1;
          break;
        case 'Medium':
          dailyHours = 2;
          break;
        case 'Hard':
          dailyHours = 3;
          break;
        default:
          dailyHours = 2;
      }

      for (int i = 0; i < 7; i++) {
        DateTime studyDate = now.add(Duration(days: i));
        String dateKey = DateFormat('yyyy-MM-dd').format(studyDate);

        if (!dailySchedule.containsKey(dateKey)) {
          dailySchedule[dateKey] = [];
        }

        dailySchedule[dateKey]!.add({
          'subject': subject['subject_name'],
          'hours': dailyHours,
          'tasks': _generateTasks(subject['difficulty'], subject['subject_name']),
        });
      }
    }

    dailySchedule.forEach((date, subjects) {
      schedule.add({
        'date': date,
        'subjects': subjects,
      });
    });

    return schedule;
  }

  List<String> _generateTasks(String difficulty, String subject) {
    List<String> tasks = [];
    tasks.add('Study $subject');
    tasks.add('Use educational websites for $subject');
    tasks.add('Watch YouTube tutorials on $subject');
    tasks.add('Solve past-year papers for $subject');

    switch (difficulty) {
      case 'Easy':
        tasks.add('Review basic concepts of $subject');
        tasks.add('Solve 5 practice questions for $subject');
        break;
      case 'Medium':
        tasks.add('Study key chapters of $subject');
        tasks.add('Solve 10 practice questions for $subject');
        tasks.add('Summarize key points for $subject');
        tasks.add('Create flashcards for $subject');
        break;
      case 'Hard':
        tasks.add('In-depth study of $subject');
        tasks.add('Solve 15 practice questions for $subject');
        tasks.add('Create mind maps or summaries for $subject');
        tasks.add('Practice past exam papers for $subject');
        tasks.add('Participate in group discussions for $subject');
        break;
    }

    return tasks;
  }

  Future<void> _saveAndGenerateSchedule() async {
    if (_subjects.isEmpty) {
      setState(() {
        _errorMessage = 'Please add at least one subject.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to save subjects.');
      }
      print('Authenticated user ID: ${user.id}');
      print('Subjects to upsert: $_subjects');

      for (var subject in _subjects) {
        final response = await supabase.from('subjects').upsert({
          'user_id': user.id,
          'subject_name': subject['subject_name'],
          'difficulty': subject['difficulty'],
          'exam_date': subject['exam_date'],
        }, onConflict: 'user_id, subject_name, exam_date');
        print('Upsert response for ${subject['subject_name']}: $response');
      }

      await _fetchSubjects();

      final schedule = _generateStudySchedule();

      if (schedule.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _schedule = schedule;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule generated successfully!')),
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to generate schedule: $error';
        _isLoading = false;
      });
      print('Error details: $error');
    }
  }

  Future<void> _selectExamDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().add(const Duration(days: 7)),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _examDate) {
      setState(() {
        _examDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a subject name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _difficultyController.text.isEmpty
                          ? 'Medium'
                          : _difficultyController.text,
                      items: _difficultyLevels.map((String level) {
                        return DropdownMenuItem(
                            value: level,
                            child: Text(level, style: const TextStyle(color: Colors.white)));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _difficultyController.text = value ?? 'Medium';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Difficulty Level',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                      dropdownColor: Colors.black,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a difficulty level';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _examDate == null
                                ? 'Select Exam Date'
                                : 'Exam Date: ${DateFormat('yyyy-MM-dd').format(_examDate!)}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectExamDate(context),
                          child: const Text('Pick Date'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _addSubject,
                          child: const Text('Add Subject'),
                        ),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _saveAndGenerateSchedule,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Generate Schedule'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_subjects.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Added Subjects:',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._subjects.map((subject) => ListTile(
                          title: Text(
                            subject['subject_name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Difficulty: ${subject['difficulty']} | Exam Date: ${subject['exam_date']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSubject(subject),
                          ),
                        )),
                  ],
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              if (_schedule.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Study Schedule:',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ..._schedule.map((daySchedule) => Card(
                          color: Colors.grey[900],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ${daySchedule['date']}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...daySchedule['subjects'].map<Widget>((subject) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Subject: ${subject['subject']}',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                        Text(
                                          'Study Hours: ${subject['hours']}',
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 14),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Tasks:',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        ...subject['tasks'].map<Widget>((task) => Text(
                                              '- $task',
                                              style: const TextStyle(
                                                  color: Colors.white, fontSize: 12),
                                            )).toList(),
                                        const SizedBox(height: 8),
                                      ],
                                    )).toList(),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}