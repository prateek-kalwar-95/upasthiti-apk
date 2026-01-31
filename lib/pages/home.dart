import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sih/pages/analyticPage.dart';
import 'package:sih/pages/qrCodePage.dart';
import 'package:sih/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  bool _cameraPermissionGranted = false;
  bool _locationPermissionGranted = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentMessageIndex = 0;
  late PageController _pageController;

  // Motivational messages similar to the images
  final List<Map<String, String>> motivationalMessages = [
    {
      "title": "The place that fits all\nyour educational needs",
      "subtitle": "Crafted with 💙 by उpasthiti"
    },
    {
      "title": "Never miss\na class!",
      "subtitle": "Crafted with ❤️ in TMSL"
    },
    {
      "title": "Your attendance\njourney starts here ✨",
      "subtitle": "Smart. Simple. Seamless."
    },
    {
      "title": "Building better\neducation habits 🎓",
      "subtitle": "One scan at a time"
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    
    // Auto-scroll through motivational messages
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % motivationalMessages.length;
        });
        _pageController.animateToPage(
          _currentMessageIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final locationStatus = await Permission.location.status;

    setState(() {
      _cameraPermissionGranted = cameraStatus.isGranted;
      _locationPermissionGranted = locationStatus.isGranted;
    });

    // If permissions are not granted, request them
    if (!_cameraPermissionGranted || !_locationPermissionGranted) {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
    ].request();

    setState(() {
      _cameraPermissionGranted = statuses[Permission.camera]?.isGranted ?? false;
      _locationPermissionGranted = statuses[Permission.location]?.isGranted ?? false;
    });
  }

  void _scanQRCode() {
    if (_cameraPermissionGranted && _locationPermissionGranted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRScannerPage(
            onScanSuccess: (subject, timestamp) {
              // setState(() {
              //   if (attendanceData[subject] == null) {
              //     attendanceData[subject] = [];
              //   }
              //   attendanceData[subject]!.add(timestamp);
              // });
              _showAttendanceConfirmation(subject, timestamp);
            },
          ),
        ),
      );
    } else {
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    List<String> missingPermissions = [];
    if (!_cameraPermissionGranted) missingPermissions.add('Camera');
    if (!_locationPermissionGranted) missingPermissions.add('Location');
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Required'),
          content: Text('${missingPermissions.join(' and ')} permissions are required to scan QR codes for attendance.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _requestPermissions();
              },
              child: const Text('Grant Permissions'),
            ),
          ],
        );
      },
    );
  }

  void _showAttendanceConfirmation(String subject, DateTime timestamp) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance marked for $subject'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAnalyticsDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentAnalyticsPage(),
      ),
    );
  }

  Widget _buildMotivationalHeader() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: motivationalMessages.length,
        onPageChanged: (index) {
          setState(() {
            _currentMessageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    motivationalMessages[index]['title']!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue[800],
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    motivationalMessages[index]['subtitle']!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        motivationalMessages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentMessageIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentMessageIndex == index 
                ? Colors.blue[600] 
                : Colors.blue[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        title: Text(widget.title),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Welcome message
                  Text(
                    'Smart Attendance System',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Scan QR codes to mark attendance',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 30),
                  // QR Scanner Container
                  GestureDetector(
                    onTap: _scanQRCode,
                    child: Container(
                      height: 280,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blue[400]!,
                          width: 3,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Corner brackets
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.blue[600]!, width: 4),
                                  left: BorderSide(color: Colors.blue[600]!, width: 4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.blue[600]!, width: 4),
                                  right: BorderSide(color: Colors.blue[600]!, width: 4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue[600]!, width: 4),
                                  left: BorderSide(color: Colors.blue[600]!, width: 4),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.blue[600]!, width: 4),
                                  right: BorderSide(color: Colors.blue[600]!, width: 4),
                                ),
                              ),
                            ),
                          ),
                          
                          // QR Code icon and text
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    size: 50,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Tap to scan',
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Analytics Dashboard Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: _showAnalyticsDashboard,
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

                  const SizedBox(height: 30),
                  
                  const SizedBox(height: 20),

                  const SizedBox(height: 10),
                  
                  // Motivational Header Section
                  _buildMotivationalHeader(),
                  const SizedBox(height: 16),
                  _buildPageIndicator(),
                  
                  const SizedBox(height: 30),
                  
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildStatCard(String label, String value) {
  //   return Column(
  //     children: [
  //       Text(
  //         value,
  //         style: TextStyle(
  //           fontSize: 28,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.blue[800],
  //         ),
  //       ),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Colors.black87,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}