#!/bin/bash
echo "🚀 Simülatör için özel derleme başlatılıyor (CodeSign Bypass Aktif)..."
xcodebuild -workspace ios/Runner.xcworkspace -scheme Runner -configuration Debug -sdk iphonesimulator SYMROOT="$(PWD)/build/ios" -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max' build CODE_SIGNING_ALLOWED=NO | grep -v warning

if [ $? -eq 0 ]; then
    echo "✅ Derleme başarılı! Simülatöre yükleniyor..."
    xcrun simctl install booted "build/ios/Debug-iphonesimulator/Runner.app"
    xcrun simctl launch booted com.kahramanapp.worldcup2026
    echo "🎉 Başarıyla simülatörde açıldı! Tasarımı inceleyebilirsiniz."
else
    echo "❌ Derleme başarısız oldu."
fi
