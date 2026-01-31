// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class StudentAnalyticsPage extends StatefulWidget {
//   @override
//   _StudentAnalyticsPageState createState() => _StudentAnalyticsPageState();
// }

// class _StudentAnalyticsPageState extends State<StudentAnalyticsPage> {
//   final user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Attendance Analytics"),
//         backgroundColor: Colors.blue[800],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .doc(user!.uid)
//             .collection('attendanceHistory')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var sessions = snapshot.data!.docs;

//           if (sessions.isEmpty) {
//             return Center(
//               child: Text(
//                 "No attendance data found.",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//             );
//           }

//           /// ✅ Group data by subject
//           Map<String, List<Map<String, dynamic>>> subjectWiseData = {};
//           for (var session in sessions) {
//             var data = session.data() as Map<String, dynamic>;
//             String subject = data['subject'] ?? 'Unknown';

//             if (!subjectWiseData.containsKey(subject)) {
//               subjectWiseData[subject] = [];
//             }
//             subjectWiseData[subject]!.add(data);
//           }

//           /// ✅ Overall Summary
//           int totalClasses = sessions.length;
//           int totalPresent = sessions.where((doc) => (doc['status'] ?? '') == 'Present').length;
//           double overallPercentage = (totalClasses > 0)
//               ? (totalPresent / totalClasses) * 100
//               : 0;

//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// ✅ Overall Attendance Summary Card
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Overall Attendance",
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         Text("Total Classes: $totalClasses"),
//                         Text("Present: $totalPresent"),
//                         Text("Percentage: ${overallPercentage.toStringAsFixed(1)}%"),
//                         SizedBox(height: 10),
//                         LinearProgressIndicator(
//                           value: overallPercentage / 100,
//                           backgroundColor: Colors.grey[300],
//                           color: Colors.blue,
//                           minHeight: 8,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),

//                 /// ✅ Subject-wise Analysis Header
//                 Text("Subject-wise Analysis",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),

//                 /// ✅ Each Subject Analytics
//                 ...subjectWiseData.entries.map((entry) {
//                   String subject = entry.key;
//                   List<Map<String, dynamic>> records = entry.value;

//                   int presentCount = records.where((r) => r['status'] == 'Present').length;
//                   int absentCount = records.where((r) => r['status'] == 'Absent').length;
//                   int total = records.length;
//                   double percentage = (total > 0) ? (presentCount / total) * 100 : 0;

//                   return Card(
//                     margin: EdgeInsets.only(bottom: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     elevation: 3,
//                     child: ExpansionTile(
//                       title: Text(
//                         "$subject",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Attendance: ${percentage.toStringAsFixed(1)}% ($presentCount / $total)"),
//                           SizedBox(height: 5),
//                           LinearProgressIndicator(
//                             value: percentage / 100,
//                             backgroundColor: Colors.grey[300],
//                             color: Colors.green,
//                             minHeight: 6,
//                           ),
//                           SizedBox(height: 5),
//                           Text("Present: $presentCount | Absent: $absentCount"),
//                         ],
//                       ),
//                       children: records.map((session) {
//                         DateTime? date = DateTime.tryParse(session['date'] ?? '');
//                         String formattedDate = date != null
//                             ? DateFormat('dd MMM yyyy, hh:mm a').format(date)
//                             : 'N/A';

//                         return ListTile(
//                           leading: Icon(Icons.calendar_today, color: Colors.blue),
//                           title: Text("Date: $formattedDate"),
//                           subtitle: Text("Status: ${session['status']}"),
//                         );
//                       }).toList(),
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class StudentAnalyticsPage extends StatefulWidget {
  @override
  _StudentAnalyticsPageState createState() => _StudentAnalyticsPageState();
}

class _StudentAnalyticsPageState extends State<StudentAnalyticsPage>
    with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 85) return Colors.green;
    if (percentage >= 75) return Colors.orange;
    return Colors.red;
  }

  IconData _getAttendanceIcon(double percentage) {
    if (percentage >= 85) return Icons.trending_up;
    if (percentage >= 75) return Icons.trending_flat;
    return Icons.trending_down;
  }

  String _getAttendanceStatus(double percentage) {
    if (percentage >= 85) return "Excellent";
    if (percentage >= 75) return "Good";
    return "Needs Improvement";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "My Analytics",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('attendanceHistory')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          var sessions = snapshot.data!.docs;

          if (sessions.isEmpty) {
            return _buildEmptyState();
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildAnalyticsContent(sessions),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            "Please try again later",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            "Loading your analytics...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            "No Data Yet",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Your attendance analytics will appear here\nonce you start attending classes",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsContent(List<QueryDocumentSnapshot> sessions) {
    // Group data by subject
    Map<String, List<Map<String, dynamic>>> subjectWiseData = {};
    for (var session in sessions) {
      var data = session.data() as Map<String, dynamic>;
      String subject = data['subject'] ?? 'Unknown';

      if (!subjectWiseData.containsKey(subject)) {
        subjectWiseData[subject] = [];
      }
      subjectWiseData[subject]!.add(data);
    }

    // Overall calculations
    int totalClasses = sessions.length;
    int totalPresent = sessions.where((doc) => (doc['status'] ?? '') == 'Present').length;
    double overallPercentage = (totalClasses > 0) ? (totalPresent / totalClasses) * 100 : 0;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallSummaryCard(totalClasses, totalPresent, overallPercentage),
                SizedBox(height: 24),
                _buildQuickStatsRow(subjectWiseData, totalClasses, totalPresent),
                SizedBox(height: 24),
                _buildSectionHeader("Subject Performance", Icons.school),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var entries = subjectWiseData.entries.toList();
                var entry = entries[index];
                return _buildSubjectCard(entry.key, entry.value, index);
              },
              childCount: subjectWiseData.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildOverallSummaryCard(int totalClasses, int totalPresent, double percentage) {
    Color statusColor = _getAttendanceColor(percentage);
    IconData statusIcon = _getAttendanceIcon(percentage);
    String statusText = _getAttendanceStatus(percentage);

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Overall Attendance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[200],
              color: statusColor,
              minHeight: 8,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Total Classes", totalClasses.toString(), Icons.class_),
              _buildStatItem("Present", totalPresent.toString(), Icons.check_circle),
              _buildStatItem("Absent", (totalClasses - totalPresent).toString(), Icons.cancel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow(Map<String, List<Map<String, dynamic>>> subjectData, int totalClasses, int totalPresent) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            "Subjects",
            subjectData.length.toString(),
            Icons.library_books,
            Colors.blue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            "This Week",
            "5", // You can calculate actual weekly attendance
            Icons.calendar_today,
            Colors.purple,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            "Streak",
            "3", // You can calculate attendance streak
            Icons.local_fire_department,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[700], size: 24),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectCard(String subject, List<Map<String, dynamic>> records, int index) {
    int presentCount = records.where((r) => r['status'] == 'Present').length;
    int absentCount = records.where((r) => r['status'] == 'Absent').length;
    int total = records.length;
    double percentage = (total > 0) ? (presentCount / total) * 100 : 0;
    
    Color subjectColor = _getAttendanceColor(percentage);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: EdgeInsets.only(bottom: 16),
          title: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: subjectColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  subject,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: subjectColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: subjectColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 12, left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$presentCount Present",
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "$absentCount Absent",
                      style: TextStyle(
                        color: Colors.red[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "$total Total",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: subjectColor,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: records.asMap().entries.map((entry) {
                  int sessionIndex = entry.key;
                  Map<String, dynamic> session = entry.value;
                  
                  DateTime? date = DateTime.tryParse(session['date'] ?? '');
                  String formattedDate = date != null
                      ? DateFormat('MMM dd, yyyy • hh:mm a').format(date)
                      : 'N/A';

                  bool isPresent = session['status'] == 'Present';
                  
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: sessionIndex < records.length - 1
                          ? Border(bottom: BorderSide(color: Colors.grey[200]!))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isPresent 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isPresent ? Icons.check_circle : Icons.cancel,
                            color: isPresent ? Colors.green : Colors.red,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                session['status'],
                                style: TextStyle(
                                  color: isPresent ? Colors.green[600] : Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}