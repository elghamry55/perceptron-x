# PerceptronX

## Interactive Single-Layer Perceptron Trainer

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Framework-02569B?logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Language-Dart-0175C2?logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/State%20Management-Cubit-764ABC" alt="Cubit" />
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84" alt="Platforms" />
</p>

PerceptronX is an interactive Flutter application developed as an educational project for the **Neural Networks** course. It helps users explore the fundamentals of the Perceptron learning model through three classic logic gates: **AND**, **NAND**, and **XOR**.

The app provides a dedicated training screen for each gate, making it easier to study how a Perceptron approaches simple logical classification problems.

## Key Features

- **Three Logic Gates:** Choose between AND, NAND, and XOR experiments.
- **Interactive Training Screens:** Open a separate training experience for the selected logic gate.
- **Perceptron State Management:** Uses Cubit to manage and reset the training state when starting a new experiment.
- **Responsive UI:** Uses Flutter ScreenUtil to adapt sizing across different screen dimensions.
- **Visual Learning Experience:** A focused interface designed to make core Neural Network concepts easier to explore.

## Logic Gates

| Logic Gate | Description | Single-Layer Perceptron |
| --- | --- | --- |
| AND | Outputs 1 only when both inputs are 1. | Linearly separable |
| NAND | Outputs 0 only when both inputs are 1. | Linearly separable |
| XOR | Outputs 1 when the two inputs are different. | Not linearly separable |

**Important:** AND and NAND can be learned by a single-layer Perceptron because their outputs are linearly separable. XOR cannot be correctly represented by a single linear decision boundary, which makes it an important example when studying the limitations of a single-layer Perceptron.

## Tech Stack

| Technology | Purpose |
| --- | --- |
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Cubit (flutter_bloc) | State management |
| flutter_screenutil | Responsive sizing and layout |
| fl_chart | Charting dependency |

## Project Structure

The application separates its Perceptron state management from the user interface:

```text
lib/
├── cubit/
│   └── perceptron_cubit.dart
└── screens/
    ├── home_screen.dart
    └── training_screen.dart
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK (included with Flutter)
- Android Studio or Visual Studio Code
- An Android emulator or a connected device

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/elghamry55/perceptron-x.git
   ```

2. Navigate to the project directory:

   ```bash
   cd perceptron-x
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Screenshots

_Add application screenshots here to demonstrate the home screen and the training experience for each logic gate._

## Project Context

This project was developed as part of the **Neural Networks** course to connect theoretical concepts with a practical, interactive Flutter application.

## Developer

**Mahmoud Elghamry**  
Flutter Developer

- GitHub: [@elghamry55](https://github.com/elghamry55)

---

**Built with Flutter and Dart.**
