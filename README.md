# 🏆 FIFA World Cup 2026 — Mobil Uygulama

> Siber-uzay temalı, glassmorphism tasarımlı FIFA Dünya Kupası 2026 takip uygulaması.

---

## 📱 Ekran Görüntüleri

| Ana Ekran | Puan Durumu | Ayarlar |
|-----------|-------------|---------|
| Maç takvimi & grup filtreleri | Tüm grupların anlık puan tablosu | Geliştirici bilgisi & linkler |

---

## ✨ Özellikler

- ⚽ **Maçlar** — Tüm grup maçlarını tarih/saat & grup filtresiyle görüntüle
- 🏅 **Puan Durumu** — 48 takımın grup bazında anlık sıralaması
- ⚙️ **Ayarlar** — Geliştirici bilgisi, EULA ve gizlilik politikası linkleri
- 🌐 **Çevrimdışı Destek** — Statik fikstür verileriyle internet olmadan çalışır

---

## 🎨 Tasarım

- **Tema:** Koyu zemin + neon siyan vurgular (Siber-uzay / Cyberpunk)
- **UI Bileşenleri:** Glassmorphism kartlar (backdrop blur + yarı saydam)
- **Tipografi:** Google Fonts (Rajdhani, Orbitron)
- **Animasyonlar:** Hover efektleri, geçiş animasyonları

---

## 🛠 Teknoloji Stack

| Katman | Teknoloji |
|--------|-----------|
| Framework | Flutter 3.x |
| State Yönetimi | Riverpod 2.x |
| Routing | GoRouter |
| Fontlar | Google Fonts |
| URL Açma | url_launcher |
| Veri | Statik JSON + Mock Data |

---

## 🚀 Kurulum

### Gereksinimler

- Flutter SDK ≥ 3.x
- Xcode ≥ 16 (iOS build için)
- CocoaPods

### Kurulum Adımları

```bash
# Repoyu klonla
git clone https://github.com/bunyamin027/worldcup-2026.git
cd worldcup-2026

# Bağımlılıkları yükle
flutter pub get

# iOS pod'larını yükle
cd ios && pod install && cd ..

# Uygulamayı çalıştır
flutter run
```

---

## 📂 Proje Yapısı

```
lib/
├── data/               # Statik maç & takım verileri
├── models/             # Veri modelleri
├── providers/          # Riverpod state provider'ları
├── router/             # GoRouter konfigürasyonu
├── screens/
│   ├── home_screen.dart        # Ana ekran (maçlar)
│   ├── standings_screen.dart   # Puan durumu
│   └── settings_screen.dart    # Ayarlar & hakkında
├── services/           # API & veri servisleri
└── main.dart           # Uygulama girişi
```

---

## 🍎 iOS Notları

- Swift Package Manager (SPM) devre dışı — `flutter config --no-enable-swift-package-manager`
- Simülatör build'leri için CodeSign devre dışı (`CODE_SIGNING_ALLOWED[sdk=iphonesimulator*] = NO`)
- Xcode'dan build için scheme **Debug** modunda olmalı

---

## 👨‍💻 Geliştirici

**kahramanapp**  
🌐 [kahramanapp.com](https://kahramanapp.com)  
📄 [Kullanıcı Sözleşmesi](https://www.kahramanapp.com/terms)  
🔒 [Gizlilik Politikası](https://www.kahramanapp.com/privacy)

---

## 📄 Lisans

Bu proje [kahramanapp](https://kahramanapp.com) tarafından geliştirilmiştir.
