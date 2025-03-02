# Color Catalog App

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue) ![Hive Version](https://img.shields.io/badge/Hive-2.x-green)

The **Color Catalog App** is a Flutter application designed to help users extract colors from images, manage a catalog of colors, and export their collections in various formats (CSV, PDF). This app leverages Hive for local storage, Palette Generator for color extraction, and Flutter's Material Design components for a seamless user experience.

---

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Dependencies](#dependencies)
5. [Contributing](#contributing)
6. [License](#license)

---

## Features

- **Image Color Extraction**: Extract dominant colors from images using the device's camera or gallery.
- **Color Management**: Add, delete, and save colors to a local database using Hive.
- **Export Options**:
  - Export your color catalog as a CSV file.
  - Generate a PDF document with color swatches.
- **Color Details**: View detailed information about each color, including Hex, RGB, CSS, Swift, SwiftUI, Objective-C, and Kotlin code snippets.
- **Clipboard Integration**: Copy color codes to the clipboard with a single tap.
- **Expandable Floating Action Button (FAB)**: Access image picking, camera, and color picker functionalities via an expandable FAB.

---

## Installation

### Prerequisites

- Flutter SDK (version 3.x or higher)
- Dart SDK (bundled with Flutter)
- Android Studio or Visual Studio Code for development
- A physical or virtual device for testing

### Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/color-catalog-app.git
   cd color-catalog-app
   ```

2. **Install Dependencies**:
   Run the following command to install all required dependencies:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Connect your device or start an emulator, then run:
   ```bash
   flutter run
   ```

---

## Usage

### Home Screen

- **Add Colors**:
  - Use the expandable FAB to pick an image from the gallery or capture one using the camera.
  - Extracted colors will be displayed in a grid view.

- **View Color Details**:
  - Tap on any color tile to view its details, including Hex, RGB, and code snippets for various platforms.

- **Export Catalog**:
  - Tap the share icon in the app bar to export your color catalog as a CSV or PDF file.

### Image Preview Screen

- After selecting or capturing an image, you can choose which extracted colors to save to your catalog.

### Color Detail Screen

- Displays detailed information about a selected color.
- Provides options to copy color codes to the clipboard or add/delete the color from the catalog.

---

## Dependencies

This project relies on the following key packages:

- **Flutter SDK**: Core framework for building the app.
- **Hive**: Lightweight, fast NoSQL database for local storage.
- **Palette Generator**: Extracts dominant colors from images.
- **Path Provider**: Provides access to the device's file system.
- **CSV**: Converts data into CSV format for exporting.
- **PDF**: Generates PDF documents for exporting color catalogs.
- **Share Plus**: Enables sharing files via native share dialogs.
- **Flutter Color Picker**: Provides a customizable color picker dialog.
- **Expandable FAB**: Implements an expandable floating action button.

You can find the full list of dependencies in the `pubspec.yaml` file.

---

## Contributing

We welcome contributions from the community! If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes with clear and concise messages.
4. Submit a pull request describing your changes.

For major changes, please open an issue first to discuss your ideas.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
