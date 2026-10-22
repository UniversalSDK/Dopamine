# Contributing to Dopamine

Thank you for your interest in contributing to Dopamine! We welcome community contributions, bug fixes, feature ideas, and translations.

## Getting Started

1. **Fork the Repository**: Create your personal fork of `UniversalSDK/Dopamine`.
2. **Clone & Build**:
   ```bash
   git clone https://github.com/<your-username>/Dopamine.git
   cd Dopamine
   ./build.sh
   ```
3. **Run & Test**: The built app will be in `./build/Dopamine.app`.
4. **Submit PR**: Create a descriptive Pull Request explaining the problem solved or feature added.

## Bug Reports & Feature Requests

Please use [GitHub Issues](https://github.com/UniversalSDK/Dopamine/issues) for:
* Bug reports (please mention your macOS version and Apple Silicon model).
* Feature suggestions (e.g. additional triggers, menu customization).

## Code Style

* Dopamine is written in 100% native Swift and AppKit.
* Keep dependencies to zero external pods/frameworks where possible to maintain our tiny footprint (< 15MB RAM).
