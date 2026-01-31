# Attendance Monitoring System 📱

A comprehensive **Flutter-based mobile application** developed for **Smart India Hackathon (SiH)** that streamlines attendance management for educational institutions and organizations.

---
## 📱 Download & Resources

You can download the **APK** and additional project files from the link below:  
🔗 [Download Attendance Monitoring System Files (Google Drive)](https://drive.google.com/drive/folders/1wT_9I6aYKSrMHZU9I3oCgSpXUA-ZKlRq?usp=sharing)

---

## 🌟 Features

### For Students
- **Easy Check-in/Check-out**: Simple and intuitive attendance marking  
- **Real-time Updates**: Instant attendance status updates  
- **Attendance History**: View personal attendance records  
- **Notifications**: Get reminders for attendance marking  
- **Profile Management**: Manage personal information and preferences  

### For Teachers/Administrators
- **Class Management**: Create and manage classes/sessions  
- **Student Monitoring**: Track individual student attendance  
- **Attendance Reports**: Generate comprehensive attendance reports  
- **Analytics Dashboard**: Visual representation of attendance data  
- **Bulk Operations**: Manage multiple students efficiently  

### Core Features
- **Cross-Platform**: Available for both Android and iOS  
- **Offline Support**: Mark attendance even without internet connectivity  
- **Secure Authentication**: User authentication and data security  
- **Location-based Tracking**: Optional geofencing for attendance validation  
- **QR Code Integration**: Quick attendance marking via QR codes  
- **Export Functionality**: Export attendance data in various formats  

---

## 🚀 Technology Stack

- **Frontend**: Flutter (Dart)  
- **Backend**: Node.js / Firebase  
- **Database**: Firebase Firestore / MongoDB  
- **Authentication**: Firebase Auth  
- **State Management**: Provider / Bloc  
- **Local Storage**: SQLite / Hive  

---

## 🛠 Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/prateek-kalwar-95/SiH.git
   cd SiH
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase (if using Firebase)**
   - Create a new Firebase project
   - Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
   - Place them in respective platform directories
   - Enable Authentication and Firestore in Firebase console

4. **Run the application**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS IPA:**
```bash
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── screens/                  # UI screens
│   ├── student/             # Student-specific screens
│   ├── teacher/             # Teacher-specific screens
│   └── common/              # Shared screens
├── services/                # Business logic and API calls
├── utils/                   # Utility functions
├── widgets/                 # Reusable widgets
└── constants/               # App constants
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the project root:
```env
API_BASE_URL=your_api_base_url
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### App Configuration
Modify `lib/config/app_config.dart` with your settings:
```dart
class AppConfig {
  static const String appName = "Attendance Monitor";
  static const String version = "1.0.0";
  // Add other configuration variables
}
```

## 🎯 Usage

### For Students
1. **Registration**: Sign up with your student credentials
2. **Login**: Access the app using your registered credentials
3. **Mark Attendance**: Use QR code scan or manual check-in
4. **View History**: Check your attendance records anytime

### For Teachers
1. **Class Setup**: Create classes and add students
2. **Generate QR**: Create QR codes for attendance sessions
3. **Monitor**: Track real-time attendance status
4. **Reports**: Generate and export attendance reports

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow Flutter/Dart coding standards
- Write clear commit messages
- Add documentation for new features
- Test your changes thoroughly

## 🧪 Testing

Run tests using:
```bash
flutter test
```

For integration tests:
```bash
flutter test integration_test/
```


**Made with ❤️ for Smart India Hackathon**
