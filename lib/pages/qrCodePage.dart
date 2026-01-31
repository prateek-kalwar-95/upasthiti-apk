import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({
    Key? key,
    required Null Function(dynamic subject, dynamic timestamp) onScanSuccess,
  }) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isFlashOn = false;
  bool isProcessing = false;
  bool hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final locationPermission = await Permission.location.request();

    setState(() {
      hasCameraPermission = cameraPermission == PermissionStatus.granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A), // Deep blue
              Color(0xFF3B82F6), // Blue
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // Flash Toggle
                    GestureDetector(
                      onTap: _toggleFlash,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // QR Scanner Frame
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Camera Scanner View
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: hasCameraPermission
                            ? MobileScanner(
                                controller: cameraController,
                                onDetect: _onDetect,
                              )
                            : Container(
                                color: Colors.black,
                                child: const Center(
                                  child: Text(
                                    'Camera permission required',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    // Scanning Frame Corners
                    SizedBox(
                      width: 280,
                      height: 280,
                      child: Stack(
                        children: [
                          // Top Left Corner
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          // Top Right Corner
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  right: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          // Bottom Left Corner
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  left: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          // Bottom Right Corner
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                  right: BorderSide(
                                    color: Colors.white,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Processing Indicator
                    if (isProcessing)
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'Processing...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Bottom Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    // App Title
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'QR SCANNER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Scan instruction text
                    const Text(
                      'Scan any QR code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status text
                    Text(
                      isProcessing
                          ? 'Processing scan...'
                          : hasCameraPermission
                          ? 'Point camera at QR code'
                          : 'Camera permission required',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),

                    if (!hasCameraPermission)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: _requestPermissions,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E3A8A),
                          ),
                          child: const Text('Grant Camera Permission'),
                        ),
                      ),

                    // GPS Enable Button
                    FutureBuilder<bool>(
                      future: Geolocator.isLocationServiceEnabled(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            !snapshot.data! &&
                            hasCameraPermission) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton(
                              onPressed: () async {
                                await Geolocator.openLocationSettings();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1E3A8A),
                              ),
                              child: const Text('Enable GPS Location'),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && !isProcessing) {
      final String? qrCode = barcodes.first.rawValue;
      if (qrCode != null && qrCode.isNotEmpty) {
        _handleQRScan(qrCode);
      }
    }
  }

  Future<void> _toggleFlash() async {
    await cameraController.toggleTorch();
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  Future<void> _handleQRScan(String qrCode) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    try {
      // Stop the camera temporarily
      await cameraController.stop();

      // Get current location
      Position position = await _getCurrentLocation();

      // Send API request
      await _sendQRData(context, qrCode, position);

      // Show success message
      _showSuccessDialog(qrCode);
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  // Future<void> _sendQRData(String qrCode, Position position) async {
  //   const String apiUrl = 'https://backend-dxwdl0z5e-akash-github-glitchs-projects.vercel.app/api/sessions/mark-attendance/0HXfz4Uzfo5FIIQWnK6r'; // Replace with your API URL

  //   final Map<String, dynamic> requestData = {
  //     'qr_code': qrCode,
  //     'location': {
  //       'latitude': position.latitude,
  //       'longitude': position.longitude,
  //       'accuracy': position.accuracy,
  //       'timestamp': DateTime.now().toIso8601String(),
  //     },
  //   };

  //   debugPrint('Sending QR Data: $requestData');

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer YOUR_API_TOKEN', // Add your token here
  //       },
  //       body: json.encode(requestData),
  //     );

  //     if (response.statusCode != 200) {
  //       throw Exception('API request failed: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     throw Exception('Network error: $e');
  //   }
  // }

  // Future<void> _sendQRData(String qrCode, Position position) async {
  //   try {
  //     // Split the QR Code data
  //     List<String> parts = qrCode.split('-');
  //     if (parts.length < 6) throw Exception('Invalid QR code format');

  //     String teacherId = parts[0];
  //     String subject = parts[1];
  //     String department = parts[2];
  //     String section = parts[3];
  //     String semester = parts[4];
  //     String deptUID = parts[5]; // optional use

  //     final user = FirebaseAuth.instance.currentUser;

  //     // ✅ Find the session in Firestore
  //     QuerySnapshot sessionSnapshot = await FirebaseFirestore.instance
  //         .collection('attendanceSessions')
  //         .where('teacherId', isEqualTo: teacherId)
  //         .where('subject', isEqualTo: subject)
  //         .where('department', isEqualTo: department)
  //         .where('section', isEqualTo: section)
  //         .where('semester', isEqualTo: semester)
  //         .where('isOpen', isEqualTo: true)
  //         .limit(1)
  //         .get();

  //     if (sessionSnapshot.docs.isEmpty) {
  //       throw Exception('Session not found or attendance closed');
  //     }

  //     var sessionDoc = sessionSnapshot.docs.first;
  //     String sessionId = sessionDoc.id;

  //     // ✅ Check if already marked in user's attendance history
  //     DocumentSnapshot historyDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user!.uid)
  //         .collection('attendanceHistory')
  //         .doc(sessionId)
  //         .get();

  //     if (historyDoc.exists) {
  //       throw Exception('Attendance already marked for this session');
  //     }

  //     // ✅ Get student details
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .get();

  //     if (!userDoc.exists) {
  //       throw Exception('User details not found');
  //     }

  //     var userData = userDoc.data() as Map<String, dynamic>;
  //     String studentName = userData['name'];
  //     String universityRollNo = userData['universityRollNo'];

  //     // ✅ Update attendance in the session document
  //     await FirebaseFirestore.instance
  //         .collection('attendanceSessions')
  //         .doc(sessionId)
  //         .update({
  //           'studentsPresent': FieldValue.arrayUnion([
  //             {'name': studentName, 'universityId': universityRollNo, 'timestamp': DateTime.now().toIso8601String(),'studentUid':user.uid},
  //           ]),
  //         });

  //     // ✅ Add attendance record in student's attendanceHistory
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('attendanceHistory')
  //         .doc(sessionId)
  //         .set({
  //           'subject': subject,
  //           'date': DateTime.now().toIso8601String(),
  //           'status': 'Present',
  //           'teacherId': teacherId,
  //           'latitude': position.latitude,
  //           'longitude': position.longitude,
  //         });
  //   } catch (e) {
  //     throw Exception('Error marking attendance: $e');
  //   }
  // }

  Future<void> _sendQRData(BuildContext context, String qrCode, Position position) async {
  try {
    // Split the QR Code data
    List<String> parts = qrCode.split('-');
    if (parts.length < 5) throw Exception('Invalid QR code format');

    String teacherId = parts[0];
    String subject = parts[1];
    String qrDepartment = parts[2];
    String qrSection = parts[3];
    String qrSemester = parts[4];
    // String deptUID = parts[5]; // optional

    final user = FirebaseAuth.instance.currentUser;

    // ✅ Get student details
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    if (!userDoc.exists) {
      throw Exception('User details not found');
    }

    var userData = userDoc.data() as Map<String, dynamic>;
    String studentName = userData['name'];
    String universityRollNo = userData['universityRollNo'];
    String studentDepartment = userData['department'] ?? '';
    String studentSection = userData['section'] ?? '';

    // ✅ Validate Department and Section
    if (studentDepartment != qrDepartment || studentSection != qrSection) {
      // Show alert dialog and pop back
      Navigator.of(context).pop();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Attendance Error"),
          content: Text("You are not allowed to mark attendance for this class.\nYour Department: $studentDepartment\nYour Section: $studentSection"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return; // Stop further execution
    }

    // ✅ Find the session in Firestore
    QuerySnapshot sessionSnapshot = await FirebaseFirestore.instance
        .collection('attendanceSessions')
        .where('teacherId', isEqualTo: teacherId)
        .where('subject', isEqualTo: subject)
        .where('department', isEqualTo: qrDepartment)
        .where('section', isEqualTo: qrSection)
        .where('semester', isEqualTo: qrSemester)
        .where('isOpen', isEqualTo: true)
        .limit(1)
        .get();

    if (sessionSnapshot.docs.isEmpty) {
      throw Exception('Session not found or attendance closed');
    }

    var sessionDoc = sessionSnapshot.docs.first;
    String sessionId = sessionDoc.id;

    // ✅ Check if already marked in user's attendance history
    DocumentSnapshot historyDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('attendanceHistory')
        .doc(sessionId)
        .get();

    if (historyDoc.exists) {
      throw Exception('Attendance already marked for this session');
    }

    // ✅ Update attendance in the session document
    await FirebaseFirestore.instance
        .collection('attendanceSessions')
        .doc(sessionId)
        .update({
          'studentsPresent': FieldValue.arrayUnion([
            {
              'name': studentName,
              'universityId': universityRollNo,
              'timestamp': DateTime.now().toIso8601String(),
              'studentUid': user.uid
            },
          ]),
        });

    // ✅ Add attendance record in student's attendanceHistory
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('attendanceHistory')
        .doc(sessionId)
        .set({
          'subject': subject,
          'date': DateTime.now().toIso8601String(),
          'status': 'Present',
          'teacherId': teacherId,
          'latitude': position.latitude,
          'longitude': position.longitude,
        });

    // ✅ Success dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Attendance marked successfully!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Pop scanner page
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  } catch (e) {
    // Show error dialog
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Pop scanner page
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}


  void _showSuccessDialog(String qrCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Scan Successful',
          style: TextStyle(color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QR Code data has been sent successfully!',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text(
              'QR Code: ${qrCode.length > 50 ? "${qrCode.substring(0, 50)}..." : qrCode}',
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Resume camera
              cameraController.start();
            },
            child: const Text(
              'Scan Again',
              style: TextStyle(color: Color(0xFF1E3A8A)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close scanner
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Scan Failed', style: TextStyle(color: Colors.black)),
        content: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cameraController.start();
            },
            child: const Text(
              'Try Again',
              style: TextStyle(color: Color(0xFF1E3A8A)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
