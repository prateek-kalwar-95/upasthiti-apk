import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sih/root/path.dart';
import 'package:sih/service/auth.dart';
import 'package:sih/teacher/analytics_page.dart';
import 'package:sih/teacher/qrPage.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  String teacherName = "";
  String? selectedDepartment;
  String? selectedSubject;
  String? selectedSection;
  String? selectedSemester;
  String qrData = '';
  bool showQR = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  User? user = FirebaseAuth.instance.currentUser;
  var data;
  Future getUserDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('teacher')
        .doc(user?.uid)
        .get();
    if (doc.exists) {
      setState(() {
        data = doc.data() as Map<String, dynamic>;
      });
      print('Document data: ${doc.data()}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document does not exist'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final List<String> _departments = [
    'Computer Science Engineering',
    'Information Technology',
    'Electronics and Communication Engineering',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Biotechnology',
    'Aerospace Engineering',
    'Automobile Engineering',
    'Data Science and Engineering',
    'Artificial Intelligence and Machine Learning',
  ];

  final List<String> _subjects = [
    'DSA',
    'DSA(LAB)',
    'CO',
    'CO(LAB)',
    'Python(LAB)',
    'DEA',
    'DEA(LAB)',
    'Economics',
    'Mathematics',
  ];

  final List<String> _sections = ['A', 'B', 'C', 'D', 'E'];

  final List<String> _semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  // String generateDepartmentUID(String department) {
  //   List<String> words = department.split(' ');
  //   String deptCode = words
  //       .map((word) => word.substring(0, 2).toUpperCase())
  //       .join('');
  //   return '${deptCode}_001';
  // }
 

  void generateQRCode() async {
    if (selectedDepartment != null &&
        selectedSection != null &&
        selectedSubject != null &&
        selectedSemester != null) {
      // ✅ Check semester
      // String deptUID = generateDepartmentUID(selectedDepartment!);
      // qrData ='${user?.uid}-$selectedSubject-$selectedDepartment-$selectedSection-$selectedSemester-$deptUID';
      qrData =
          '${user?.uid}-$selectedSubject-$selectedDepartment-$selectedSection-$selectedSemester';

      // ✅ Store session in Firestore
      DocumentReference sessionRef = FirebaseFirestore.instance
          .collection('attendanceSessions')
          .doc();
      await sessionRef.set({
        'sessionId': sessionRef.id,
        'teacherId': user?.uid,
        'department': selectedDepartment,
        'section': selectedSection,
        'subject': selectedSubject,
        'semester': selectedSemester, // ✅ Added semester
        'date': DateTime.now().toIso8601String(),
        'isOpen': true,
        'studentsPresent': [],
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRCodePage(
            qrData: qrData,
            sessionId: sessionRef.id,
            department: selectedDepartment!,
            section: selectedSection!,
            subject: selectedSubject!,
            semester: selectedSemester!, // ✅ Pass semester
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void resetForm() {
    setState(() {
      selectedDepartment = null;
      selectedSubject = null;
      qrData = '';
      showQR = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => UserSelectionPage()),
                (route) => false,
              );
            },
          ),
        ],
        title: Text(
          'Teacher Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue[200]!, width: 1),
              ),
              child: Column(
                children: [
                  Icon(Icons.account_circle, size: 60, color: Colors.blue[800]),
                  SizedBox(height: 10),
                  Text(
                    'Welcome, ${data?['Name'] ?? 'Teacher'}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // QR Code Generation Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate Subject QR Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Department Dropdown
                  Text(
                    'Select Department',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true, // ✅ Added
                      value: selectedDepartment,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        hintText: 'Choose a department',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      items: _departments.map((String department) {
                        return DropdownMenuItem<String>(
                          value: department,
                          child: Text(
                            department,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDepartment = newValue;
                          selectedSubject = null;
                          showQR = false;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Select Section',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedSection,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        hintText: 'Choose a section',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      items: _sections.map((String section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Text(
                            section,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSection = newValue;
                          showQR = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Semester',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedSemester,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        hintText: 'Choose a semester',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      items: _semesters.map((String semester) {
                        return DropdownMenuItem<String>(
                          value: semester,
                          child: Text(
                            semester,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSemester = newValue;
                          showQR = false;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 20),
                  // Subject Dropdown
                  Text(
                    'Select Subject',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedSubject,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        hintText: 'Choose a subject',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      items: _subjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(
                            subject,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubject = newValue;
                          showQR = false;
                        });
                      },
                    ),
                  ),

                  SizedBox(height: 30),

                  // Generate QR Button Row
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: generateQRCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Generate QR Code',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: resetForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),
            // Analytics Dashboard Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TeacherAnalyticsPage(teacherId: user?.uid ?? ''),
                    ),
                  );
                },
                icon: const Icon(Icons.analytics, size: 28),
                label: const Text(
                  'View Analytics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
