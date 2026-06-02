#!/usr/bin/env sh
# CI-lite local check (Slice 0.2): analyze, test, and run drift codegen.
# Usage: sh tool/check.sh
set -e
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs
echo "All checks passed."
