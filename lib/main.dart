import 'package:flutter/material.dart';

void main() {
  runApp(IPKCalculator());
}

class IPKCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menghitung IPK Mahasiswa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IPKCalculatorPage(),
    );
  }
}

class IPKCalculatorPage extends StatefulWidget {
  @override
  _IPKCalculatorPageState createState() => _IPKCalculatorPageState();
}

class _IPKCalculatorPageState extends State<IPKCalculatorPage> {
  List<List<Map<String, dynamic>>> semesters = [[]];
  TextEditingController subjectController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  double calculateSemesterGPA(List<Map<String, dynamic>> semester) {
    double totalPoints = 0;
    double totalCredits = 0;

    for (var course in semester) {
      double gradePoint = calculateGradePoint(course['grade']);
      totalPoints += course['sks'] * gradePoint;
      totalCredits += course['sks'];
    }

    double semesterGPA = totalPoints / totalCredits;
    return semesterGPA.isNaN ? 0.0 : semesterGPA;
  }

  double calculateGPA() {
    double totalSemesterPoints = 0;
    double totalSemesterCredits = 0;

    for (var semester in semesters) {
      double semesterGPA = calculateSemesterGPA(semester);
      totalSemesterPoints += semesterGPA * semester.length;
      totalSemesterCredits += semester.length;
    }

    double gpa = totalSemesterPoints / totalSemesterCredits;

    // Batasi nilai IPK maksimal 4.00
    return gpa > 4.0 ? 4.0 : gpa;
  }

  double calculateGradePoint(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'B+':
        return 3.5;
      case 'B':
        return 3.0;
      case 'C+':
        return 2.5;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menghitung IPK Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: semesters.length,
                itemBuilder: (context, semesterIndex) {
                  var semester = semesters[semesterIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Semester ${semesterIndex + 1}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: semester.length,
                        itemBuilder: (context, courseIndex) {
                          var course = semester[courseIndex];
                          return Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  initialValue: course['subject'],
                                  onChanged: (value) {
                                    setState(() {
                                      semester[courseIndex]['subject'] = value;
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Mata Kuliah'),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  initialValue: course['sks']?.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      semester[courseIndex]['sks'] = double.tryParse(value);
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Sks'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: course['grade'],
                                  items: ['A', 'B+', 'B', 'C+', 'C', 'D']
                                      .map((grade) => DropdownMenuItem<String>(
                                    value: grade,
                                    child: Text(grade),
                                  ))
                                      .toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      semester[courseIndex]['grade'] = value!;
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Nilai'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            semester.add({
                              'subject': '',
                              'sks': null,
                              'grade': 'A',
                            });
                          });
                        },
                        child: Text('Tambah Mata Kuliah'),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  semesters.add([]);
                });
              },
              child: Text('Tambah Semester'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String details = '';
                    double totalGPA = 0.0;
                    for (var semesterIndex = 0; semesterIndex < semesters.length; semesterIndex++) {
                      var semester = semesters[semesterIndex];
                      double semesterGPA = calculateSemesterGPA(semester);
                      totalGPA += semesterGPA;
                      details += 'Semester ${semesterIndex + 1}, IP Semester: ${semesterGPA.toStringAsFixed(2)} \n';
                      for (var courseIndex = 0; courseIndex < semester.length; courseIndex++) {
                        var course = semester[courseIndex];
                        details += '   Mata Kuliah: ${course['subject']}, Sks: ${course['sks']}, Nilai: ${course['grade']} \n';
                      }
                    }
                    return AlertDialog(
                      title: Text('IPK'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('IPK Anda Adalah: ${(totalGPA / semesters.length).toStringAsFixed(2)}'),
                          SizedBox(height: 10),
                          Text('Detail:'),
                          Text(details),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Tutup'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Hitung IPK'),
            ),
          ],
        ),
      ),
    );
  }
}