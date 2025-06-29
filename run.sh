#!/bin/bash

echo "🐎 Starting Vealth Flutter Web App..."

if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed."
    exit 1
fi

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🌐 Enabling Flutter web..."
flutter config --enable-web

echo "🚀 Starting Flutter web server..."
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 3000
