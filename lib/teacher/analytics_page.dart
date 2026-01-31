import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAnalyticsPage extends StatelessWidget {
  final String teacherId;

  TeacherAnalyticsPage({required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Class Analytics",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendanceSessions')
            .where('teacherId', isEqualTo: teacherId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red[400]),
                  SizedBox(height: 16),
                  Text(
                    "Error loading analytics",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${snapshot.error}",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue[700]),
                  SizedBox(height: 16),
                  Text(
                    "Loading analytics...",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          var sessions = snapshot.data!.docs;

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text(
                    "No classes taken yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Analytics will appear here once you start taking classes",
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group sessions by Department -> Semester -> Subject
          Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> groupedData = {};

          for (var session in sessions) {
            var data = session.data() as Map<String, dynamic>;
            String department = data['department'] ?? 'Unknown Department';
            String semester = data['semester'] ?? 'Unknown Semester';
            String subject = data['subject'] ?? 'Unknown Subject';

            if (!groupedData.containsKey(department)) {
              groupedData[department] = {};
            }
            if (!groupedData[department]!.containsKey(semester)) {
              groupedData[department]![semester] = {};
            }
            if (!groupedData[department]![semester]!.containsKey(subject)) {
              groupedData[department]![semester]![subject] = [];
            }
            groupedData[department]![semester]![subject]!.add(data);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Statistics
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue[600]!, Colors.blue[800]!],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.analytics, size: 40, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        "Teaching Analytics",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard("Total Classes", "${sessions.length}"),
                          _buildStatCard("Departments", "${groupedData.length}"),
                          _buildStatCard("Subjects", "${_getTotalSubjects(groupedData)}"),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // Department-wise Analytics
                ...groupedData.entries.map((departmentEntry) {
                  String department = departmentEntry.key;
                  var semestersMap = departmentEntry.value;
                  int totalDeptClasses = _getTotalClassesInDepartment(semestersMap);

                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        childrenPadding: EdgeInsets.only(bottom: 15),
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.indigo[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.school, color: Colors.indigo[700], size: 24),
                        ),
                        title: Text(
                          department,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            "$totalDeptClasses classes • ${semestersMap.length} semesters",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        children: semestersMap.entries.map((semesterEntry) {
                          String semester = semesterEntry.key;
                          var subjectsMap = semesterEntry.value;
                          int totalSemClasses = _getTotalClassesInSemester(subjectsMap);

                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[100]!),
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              childrenPadding: EdgeInsets.only(bottom: 10),
                              leading: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(Icons.calendar_today, color: Colors.blue[700], size: 16),
                              ),
                              title: Text(
                                semester,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[800],
                                ),
                              ),
                              subtitle: Text(
                                "$totalSemClasses classes • ${subjectsMap.length} subjects",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                              children: subjectsMap.entries.map((subjectEntry) {
                                String subject = subjectEntry.key;
                                var subjectSessions = subjectEntry.value;

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    childrenPadding: EdgeInsets.only(bottom: 8),
                                    leading: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(Icons.book, color: Colors.green[700], size: 14),
                                    ),
                                    title: Text(
                                      subject,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${subjectSessions.length} classes taken",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    children: subjectSessions.map((data) {
                                      var students = (data['studentsPresent'] ?? []) as List;
                                      var dateString = data['date'] ?? '';
                                      DateTime? date = DateTime.tryParse(dateString);

                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey[200]!),
                                        ),
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          childrenPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          leading: Container(
                                            padding: EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: Colors.orange[100],
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Icon(Icons.class_, color: Colors.orange[700], size: 12),
                                          ),
                                          title: Text(
                                            "${data['section'] ?? 'N/A'}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Icon(Icons.calendar_month, size: 12, color: Colors.grey[500]),
                                              SizedBox(width: 4),
                                              Text(
                                                "${date != null ? "${date.day}/${date.month}/${date.year}" : 'N/A'}",
                                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                              ),
                                              SizedBox(width: 12),
                                              Icon(Icons.people, size: 12, color: Colors.grey[500]),
                                              SizedBox(width: 4),
                                              Text(
                                                "${students.length}",
                                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                          children: students.isEmpty
                                              ? [
                                                  Container(
                                                    padding: EdgeInsets.all(12),
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          "No students marked attendance",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[600],
                                                            fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ]
                                              : students.map<Widget>((student) {
                                                  var studentName = student['name'] ?? 'Unknown';
                                                  var studentId = student['universityId'] ?? 'N/A';

                                                  return Container(
                                                    margin: EdgeInsets.only(bottom: 4),
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green[50],
                                                      borderRadius: BorderRadius.circular(6),
                                                      border: Border.all(color: Colors.green[200]!),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.green[200],
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          child: Icon(
                                                            Icons.person,
                                                            color: Colors.green[700],
                                                            size: 12,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                studentName,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Colors.black87,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                              Text(
                                                                "ID: $studentId",
                                                                style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.grey[600],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.check_circle,
                                                          color: Colors.green[600],
                                                          size: 14,
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalSubjects(Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> groupedData) {
    Set<String> allSubjects = {};
    groupedData.values.forEach((semestersMap) {
      semestersMap.values.forEach((subjectsMap) {
        allSubjects.addAll(subjectsMap.keys);
      });
    });
    return allSubjects.length;
  }

  int _getTotalClassesInDepartment(Map<String, Map<String, List<Map<String, dynamic>>>> semestersMap) {
    int total = 0;
    semestersMap.values.forEach((subjectsMap) {
      subjectsMap.values.forEach((sessions) {
        total += sessions.length;
      });
    });
    return total;
  }

  int _getTotalClassesInSemester(Map<String, List<Map<String, dynamic>>> subjectsMap) {
    int total = 0;
    subjectsMap.values.forEach((sessions) {
      total += sessions.length;
    });
    return total;
  }
}