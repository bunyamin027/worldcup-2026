import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart'; // CyberColors ve tema renkleri

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  /// Genel URL başlatıcı
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Açılamayan URL: $urlString');
    }
  }

  /// Mailto başlatıcı
  Future<void> _launchEmail() async {
    final String subject = Uri.encodeComponent('Dünya Kupası 2026 Destek');
    final Uri emailLaunchUri = Uri.parse('mailto:kahramandev01@gmail.com?subject=$subject');

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      debugPrint('E-posta uygulaması açılamadı');
    }
  }

  /// Label (Etiket) stili
  TextStyle get _labelStyle => GoogleFonts.orbitron(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: Colors.white.withOpacity(0.5),
      );

  /// Değer (Ana Metin) stili
  TextStyle get _valueStyle => GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: Colors.white,
        shadows: [
          Shadow(
            color: CyberColors.neonCyan.withOpacity(0.5),
            blurRadius: 8,
          ),
        ],
      );

  /// Glassmorphism kart üretici fonksiyonu
  Widget _buildGlassCard({required Widget child, VoidCallback? onTap}) {
    final card = Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CyberColors.neonCyan.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: CyberColors.neonCyan.withOpacity(0.15),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.02),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberColors.background,
      appBar: AppBar(
        title: Text(
          'AYARLAR & BİLGİ',
          style: GoogleFonts.orbitron(
            color: CyberColors.neonCyan,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: CyberColors.neonCyan.withOpacity(0.6),
                blurRadius: 12,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: CyberColors.neonCyan),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Geliştirici (Tıklanmaz, sade metin)
            _buildGlassCard(
              child: Row(
                children: [
                  const Icon(Icons.code, color: CyberColors.neonCyan),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Geliştirici', style: _labelStyle),
                        const SizedBox(height: 4),
                        Text('kahramanapp', style: _valueStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Geliştirici Web Sitesi
            _buildGlassCard(
              onTap: () => _launchUrl('https://kahramanapp.com'),
              child: Row(
                children: [
                  const Icon(Icons.language, color: CyberColors.neonCyan),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Web Sitesi', style: _labelStyle),
                        const SizedBox(height: 4),
                        Text('kahramanapp.com', style: _valueStyle),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, color: CyberColors.neonCyan.withOpacity(0.5), size: 18),
                ],
              ),
            ),

            // 3. Kullanıcı Sözleşmesi (EULA)
            _buildGlassCard(
              onTap: () => _launchUrl('https://www.kahramanapp.com/terms'),
              child: Row(
                children: [
                  const Icon(Icons.gavel, color: CyberColors.neonCyan),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text('Kullanıcı Sözleşmesi', style: _valueStyle),
                  ),
                  Icon(Icons.open_in_new, color: CyberColors.neonCyan.withOpacity(0.5), size: 18),
                ],
              ),
            ),

            // 4. Gizlilik Politikası
            _buildGlassCard(
              onTap: () => _launchUrl('https://www.kahramanapp.com/privacy'),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip_outlined, color: CyberColors.neonCyan),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text('Gizlilik Politikası', style: _valueStyle),
                  ),
                  Icon(Icons.open_in_new, color: CyberColors.neonCyan.withOpacity(0.5), size: 18),
                ],
              ),
            ),

            // 5. İletişim & Destek
            _buildGlassCard(
              onTap: _launchEmail,
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: CyberColors.neonCyan),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('İletişim & Destek', style: _valueStyle),
                        const SizedBox(height: 4),
                        Text('kahramandev01@gmail.com', style: _labelStyle.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Icon(Icons.open_in_new, color: CyberColors.neonCyan.withOpacity(0.5), size: 18),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Center(
              child: Text(
                'v1.0.0',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: CyberColors.textSecondary.withOpacity(0.3),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
