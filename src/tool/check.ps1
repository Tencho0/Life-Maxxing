# CI-lite local check (Slice 0.2): analyze, test, and run drift codegen.
# Usage: pwsh tool/check.ps1  (or  powershell -File tool\check.ps1)
$ErrorActionPreference = 'Stop'
flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
dart run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host 'All checks passed.'
