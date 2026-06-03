# 💰 Expense Management App

[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart)](https://dart.dev/)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue?logo=python)](https://www.python.org/)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com/)
[![iOS/Android](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-blue?logo=android)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**Ứng dụng di động quản lý chi tiêu cá nhân - Ghi chép, phân loại, thống kê chi tiêu hàng ngày**

---

## 📌 Giới Thiệu

Expense Management App là ứng dụng di động được xây dựng bằng **Flutter** (Dart), giúp bạn quản lý chi tiêu cá nhân một cách dễ dàng:

- 📝 **Ghi chép chi tiêu** - Ghi lại mỗi khoản chi tiêu nhanh chóng
- 📊 **Phân loại chi tiêu** - Chia chi tiêu theo danh mục
- 💵 **Theo dõi số dư** - Biết đã chi tiêu bao nhiêu
- 📈 **Thống kê & báo cáo** - Xem xu hướng chi tiêu
- 💬 **Ghi chú chi tiết** - Thêm ghi chú cho từng khoản chi
- 🔔 **Nhắc nhở chi tiêu** - Cảnh báo chi quá nhiều

---

## 🎯 Tính Năng Chính

### 📝 Ghi Chép Chi Tiêu
- ✅ Thêm khoản chi tiêu mới
- ✅ Chọn danh mục (ăn, xăng, giặt, v.v.)
- ✅ Nhập số tiền
- ✅ Thêm ghi chú
- ✅ Chọn ngày, thời gian
- ✅ Tính toán tự động

### 📊 Phân Loại & Thống Kê
- ✅ Xem chi tiêu theo danh mục
- ✅ Thống kê chi tiêu theo ngày/tuần/tháng
- ✅ Biểu đồ chi tiêu
- ✅ So sánh chi tiêu giữa các tháng
- ✅ Dự báo chi tiêu

### 💰 Quản Lý Ngân Sách
- ✅ Đặt ngân sách hàng tháng
- ✅ Theo dõi chi tiêu so với ngân sách
- ✅ Cảnh báo khi sắp vượt ngân sách
- ✅ Điều chỉnh ngân sách linh hoạt

### 📱 Tính Năng Ứng Dụng
- ✅ Giao diện thân thiện, dễ sử dụng
- ✅ Tìm kiếm nhanh khoản chi tiêu
- ✅ Chỉnh sửa/xóa khoản chi tiêu
- ✅ Export dữ liệu (Excel, PDF)
- ✅ Sao lưu dữ liệu lên cloud

### 🔒 Bảo Mật & Dữ Liệu
- ✅ Mã hóa dữ liệu nhạy cảm
- ✅ Sao lưu tự động
- ✅ Đồng bộ multi-device
- ✅ Khôi phục dữ liệu

---

## 🛠️ Công Nghệ Sử Dụng

### Frontend
- **Dart 3.0+** - Ngôn ngữ lập trình
- **Flutter 3.0+** - Framework UI
- **GetX / Provider** - State management
- **HTTP Client** - API communication

### Backend
- **Python 3.8+**
- **Flask / FastAPI** - Web framework
- **SQLAlchemy** - ORM

### Database & Cloud
- **Firebase Firestore** - Real-time database
- **Firebase Authentication** - Xác thực người dùng
- **Firebase Storage** - Lưu trữ dữ liệu
- **SQLite** - Local storage

### Native
- **C++** - Platform-specific code

---

## 📦 Cấu Trúc Dự Án

```
Expense-Management-App/
├── expense_app/              # Flutter app chính
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── add_expense_screen.dart
│   │   │   ├── statistics_screen.dart
│   │   │   ├── budget_screen.dart
│   │   │   └── ...
│   │   ├── models/
│   │   │   ├── expense.dart
│   │   │   ├── category.dart
│   │   │   └── ...
│   │   ├── services/
│   │   │   ├── firestore_service.dart
│   │   │   ├── api_service.dart
│   │   │   └── ...
│   │   ├── widgets/
│   │   ├── utils/
│   │   └── constants/
│   ├── android/              # Android native code
│   ├── ios/                  # iOS native code
│   ├── web/                  # Web version
│   ├── test/
│   ├── pubspec.yaml         # Dependencies
│   ├── pubspec.lock
│   └── .env.example
├── API_flash_2/              # Python backend API
│   ├── app.py
│   ├── models/
│   ├── routes/
│   ├── requirements.txt
│   └── config.py
├── DoAn_QLChiTieu.pdf        # Project documentation
└── .gitignore
```

---

## 🚀 Hướng Dẫn Cài Đặt

### ✅ Yêu Cầu Hệ Thống
- **Flutter 3.0+** - Download từ https://flutter.dev
- **Dart 3.0+** - Kèm theo Flutter
- **Android Studio** hoặc **Xcode** (tùy OS)
- **Git**
- **Python 3.8+** (nếu phát triển backend)

### 1️⃣ Cài Đặt Flutter & Dart

**Windows:**
```bash
# Download Flutter SDK từ https://flutter.dev/docs/get-started/install/windows
# Giải nén vào thư mục C:\flutter

# Thêm Flutter vào PATH
# Control Panel → System → Advanced system settings → Environment Variables
# Thêm C:\flutter\bin vào PATH

# Kiểm tra cài đặt
flutter --version
dart --version
```

**macOS/Linux:**
```bash
# Sử dụng package manager
brew install flutter  # macOS
# Hoặc download từ https://flutter.dev

# Kiểm tra
flutter --version
```

### 2️⃣ Clone Repository

```bash
git clone https://github.com/DevBaor/Expense-Management-App.git
cd Expense-Management-App/expense_app

# Lấy dependencies
flutter pub get
```

### 3️⃣ Cấu Hình Firebase (Tùy chọn)

**Android:**
1. Tạo project trên Firebase Console
2. Download `google-services.json`
3. Copy vào `android/app/`

**iOS:**
1. Download `GoogleService-Info.plist` từ Firebase
2. Copy vào Xcode project

### 4️⃣ Chạy Ứng Dụng

**Android Emulator:**
```bash
# Khởi động emulator
flutter emulators --launch Pixel_5_API_30

# Chạy app
flutter run
```

**Physical Device:**
```bash
# Bật USB Debugging trên device
# Kết nối device với máy tính

# Chạy
flutter run

# Hoặc build APK
flutter build apk --release
```

**iOS (macOS):**
```bash
# Cần máy Mac với Xcode
flutter run -d <device_id>

# Hoặc build IPA
flutter build ios --release
```

### 5️⃣ Cài Đặt Backend (Python API - Optional)

```bash
cd ../API_flash_2

# Tạo virtual environment
python -m venv venv

# Activate
# Windows
venv\Scripts\activate
# Mac/Linux
source venv/bin/activate

# Cài dependencies
pip install -r requirements.txt

# Chạy API
python app.py

# Hoặc sử dụng Uvicorn
uvicorn app:app --port 5000 --reload
```

---

## 📖 Hướng Dẫn Sử Dụng

### 🏠 Màn Hình Chính (Home)
- Xem chi tiêu hôm nay, tuần này, tháng này
- Tổng chi tiêu toàn bộ
- Nút nhanh "Thêm Chi Tiêu"

### ➕ Thêm Khoản Chi Tiêu
1. Tap nút "+" hoặc "Thêm Chi Tiêu"
2. Chọn danh mục (Ăn, Xăng, Giặt, v.v.)
3. Nhập số tiền
4. Thêm ghi chú (tùy chọn)
5. Chọn ngày, giờ
6. Tap "Lưu"

### 📊 Xem Thống Kê
1. Tab **Thống Kê** → **Biểu Đồ**
2. Chọn khoảng thời gian (Ngày/Tuần/Tháng)
3. Xem chi tiêu theo danh mục
4. Scroll xem chi tiết

### 💳 Quản Lý Ngân Sách
1. Menu **Ngân Sách**
2. Đặt ngân sách tháng
3. Hệ thống sẽ cảnh báo khi sắp vượt

### 🔍 Tìm Kiếm Chi Tiêu
1. Tap biểu tượng tìm kiếm
2. Nhập số tiền hoặc danh mục
3. Xem lịch sử chi tiêu

### 📤 Export Dữ Liệu
1. Menu → Export
2. Chọn định dạng (Excel, PDF)
3. Chọn khoảng thời gian
4. Download

---

## ⚙️ Cấu Hình Nâng Cao

### Thay Đổi Danh Mục Chi Tiêu
**File**: `lib/constants/categories.dart`

```dart
const List<String> EXPENSE_CATEGORIES = [
  'Ăn uống',
  'Xăng dầu',
  'Giặt giũ',
  'Y tế',
  'Giáo dục',
  'Giải trí',
  'Mua sắm',
  'Khác'
];
```

### Cấu Hình API Backend
**File**: `lib/constants/config.dart`

```dart
const String API_BASE_URL = 'http://localhost:5000/api';
const String FIREBASE_PROJECT_ID = 'your-project-id';
```

### Thay Đổi Giao Diện (Theme)
**File**: `lib/main.dart`

```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  useMaterial3: true,
),
```

---

## 🔧 Build & Deployment

### Build APK (Android)
```bash
# Debug
flutter build apk

# Release
flutter build apk --release
# APK nằm tại: build/app/outputs/apk/release/app-release.apk
```

### Build IPA (iOS)
```bash
flutter build ios --release
# IPA nằm tại: build/ios/ipa/
```

### Build Web
```bash
flutter build web --release
```

### Deploy lên Play Store / App Store
```bash
# Android Play Store
flutter build appbundle --release
# Upload tại: Google Play Console

# iOS App Store
flutter build ios --release
# Upload qua Xcode hoặc Transporter
```

---

## ❓ Troubleshooting

### Lỗi "Flutter SDK not found"
```
❌ flutter: command not found
✅ Thêm Flutter path vào PATH environment variable
```

### Lỗi "Android SDK not found"
```
❌ No Android SDK found
✅ Chạy: flutter config --android-sdk-path /path/to/android/sdk
```

### Lỗi Build Gradle
```
❌ Gradle build failed
✅ Chạy: flutter clean && flutter pub get && flutter run
```

### Lỗi Firebase Connection
```
❌ Cannot connect to Firebase
✅ Kiểm tra google-services.json/GoogleService-Info.plist đã cấu hình đúng
```

---

## 📚 Danh Mục Tài Liệu

- [DoAn_QLChiTieu.pdf](DoAn_QLChiTieu.pdf) - Báo cáo đồ án chi tiết

---

## 👨‍💻 Người Phát Triển

- **Duy Bảo (DevBaor)** - Lead Developer
- **Nhóm 4** - Development Team

---

## 🔗 Liên Kết

- 📧 Email: duybaot105@gmail.com
- 🔗 LinkedIn: [Duy Bảo](https://linkedin.com/in/duybaot105)
- 💻 GitHub: [@DevBaor](https://github.com/DevBaor)

---

## 📝 License

Dự án này được cấp phép theo **MIT License** - xem file [LICENSE](LICENSE) để chi tiết.

---

**Made with ❤️ by Duy Bảo - Expense Management Team**
