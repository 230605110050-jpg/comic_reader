<div align="center">

<h1 style="font-size:48px; font-weight:900; margin-bottom:10px; letter-spacing:2px;">
COMIC READER APP
</h1>

<p style="font-size:16px; max-width:700px;">
A modern, feature-rich Flutter application for reading manga/comics with offline capabilities, user authentication, and a beautiful Material Design interface.
</p>

<div style="margin-top:20px;">

<img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white" />

</div>

</div>

## Features

### Core Features
- **Manga Reading**: Full-featured manga reader with chapter navigation
- **Search & Filter**: Search manga by title with real-time filtering
- **Favorites System**: Save and manage favorite manga
- **Reading History**: Track reading progress and history
- **User Authentication**: Secure login and registration system

### User Experience
- **Responsive Design**: Optimized for mobile and tablet
- **Fast Loading**: Cached images and smooth navigation
- **Pull-to-Refresh**: Easy data refresh functionality
- **Pagination**: Efficient loading of large manga lists

### Technical Features
- **Clean Architecture**: Separated UI, business logic, and data layers
- **REST API Integration**: Robust API communication with error handling
- **Local Database**: SQLite for offline data storage
- **Secure Storage**: Encrypted user credentials
- **State Management**: GetX for reactive state management

## Tech Stack

### Frontend
- **Flutter** (>=2.17.0) - UI Framework
- **Dart** - Programming Language
- **Material Design** - Design System

### State Management & Navigation
- **GetX** (^4.6.5) - State management and routing

### Networking & Data
- **HTTP** (^1.6.0) - API communication
- **Cached Network Image** (^3.4.1) - Image caching
- **SQLite** (^2.2.0+3) - Local database
- **Shared Preferences** - Simple data storage
- **Flutter Secure Storage** (^9.2.4) - Encrypted storage

### Utilities
- **Path Provider** (^2.0.13) - File system access
- **File Picker** (^8.0.0) - File selection
- **Crypto** (^3.0.7) - Cryptographic functions

## API Endpoints

The app integrates with a Laravel-based manga scraper API hosted on Vercel.

### Base URL
```
https://laravel-api-manga-scraper.vercel.app/api/api
```

### Endpoints

#### 1. Get Latest Manga (Paginated)
```http
GET /terbaru/{page}
```

**Parameters:**
- `page` (integer): Page number (default: 1)

**Response:**
```json
{
  "success": true,
  "data": {
    "current_page": 1,
    "total_page": 10,
    "data": [
      {
        "title": "Manga Title",
        "ratting": "8.5",
        "chapter": "Chapter 143",
        "img": "https://...",
        "url": "manga-slug"
      }
    ]
  }
}
```

#### 2. Get Manga Details
```http
GET /detail/{slug}
```

**Parameters:**
- `slug` (string): Manga slug/identifier

**Response:**
```json
{
  "success": true,
  "data": {
    "title": "Manga Title",
    "img": "https://...",
    "ratting": "8.5",
    "short_sinopsis": "Synopsis...",
    "status": "Ongoing",
    "pengarang": "Author Name",
    "tema": ["Action", "Adventure"],
    "chapter": [
      {
        "url": "chapter-slug",
        "chapter": "Chapter 143",
        "update": "2024-01-15"
      }
    ],
    "mirip": [
      {
        "url": "similar-manga-slug",
        "img": "https://...",
        "title": "Similar Manga",
        "subtitle": "Action, Adventure"
      }
    ]
  }
}
```

#### 3. Get Chapter Images
```http
GET /baca/{chapter_slug}
```

**Parameters:**
- `chapter_slug` (string): Chapter slug/identifier

**Response:**
```json
{
  "success": true,
  "data": {
    "img": [
      "https://image1.jpg",
      "https://image2.jpg"
    ],
    "back_chapter": "previous-chapter-slug",
    "next_chapter": "next-chapter-slug"
  }
}
```

## Installation & Setup

### Prerequisites
- **Flutter SDK** (>=2.17.0)
- **Dart SDK** (>=2.17.0)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android/iOS Simulator** or physical device

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/comic-reader.git
   cd comic-reader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure for your platform**

   **For Android:**
   - Ensure Android SDK is properly configured
   - Create `android/app/src/main/AndroidManifest.xml` if needed

   **For iOS:**
   - Ensure Xcode is installed
   - Run `pod install` in `ios/` directory

4. **Run the app**
   ```bash
   # Debug mode
   flutter run

   # Release build
   flutter build apk  # For Android
   flutter build ios  # For iOS
   ```

### Development Setup

1. **Enable Flutter web support** (optional)
   ```bash
   flutter config --enable-web
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Code formatting**
   ```bash
   flutter format lib/
   ```

4. **Analyze code**
   ```bash
   flutter analyze
   ```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── manga_detail.dart        # Manga detail model
│   ├── manga_list_item.dart     # Manga list item model
│   └── user_model.dart          # User model
├── services/                    # Business logic layer
│   ├── api/
│   │   └── manga_api_service.dart # API communication
│   └── local/                   # Local data services
│       ├── auth_service_local.dart
│       ├── favorites_service.dart
│       ├── history_service.dart
│       └── db_helper.dart
├── views/                       # UI layer
│   ├── auth/                    # Authentication views
│   │   ├── login_view.dart
│   │   └── register_view.dart
│   ├── manga/                   # Manga-related views
│   │   ├── home_view.dart       # Home screen
│   │   ├── list_view.dart       # Manga list with search
│   │   ├── detail_view.dart     # Manga details
│   │   └── reader_view.dart     # Chapter reader
│   ├── reader/                  # Reader-specific views
│   │   └── account_reader_view.dart
│   ├── author/                  # Author views
│   │   ├── account_author_view.dart
│   │   └── author_setting_view.dart
│   └── core/                    # Core UI components
│       ├── main_wrapper.dart    # Main app wrapper
│       └── placeholder_view.dart
└── widgets/                     # Reusable widgets (if any)
```

## Screenshots

### Home Screen
*Beautiful home screen with featured manga and trending sections*

### Manga List with Search
*Search functionality with real-time filtering*

### Manga Reader
*Smooth chapter reading experience with navigation*

### User Profile
*User dashboard with favorites and reading history*

*Screenshots will be added soon*

## 🔧 Configuration

### API Configuration
Update the base URL in `lib/services/api/manga_api_service.dart`:
```dart
static const String baseUrl = 'YOUR_API_BASE_URL';
```

### Database Configuration
The app uses SQLite for local storage. Database files are stored in:
- **Android**: `data/data/com.example.comic_reader/databases/`
- **iOS**: `Documents/` directory

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Use meaningful commit messages
- Write clean, readable code
- Add comments for complex logic
- Test your changes thoroughly

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **Flutter Team** for the amazing framework
- **Material Design** for the design system
- **Laravel API Manga Scraper** for providing the backend API
- **GetX** for state management
- **Cached Network Image** for image caching

## Support

If you have any questions or issues, please:
- Open an issue on GitHub
- Contact the maintainers
- Check the documentation

---

**Made with Flutter**
