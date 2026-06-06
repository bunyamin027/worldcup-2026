import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _allFixtures = [];
  bool _isLoading = true;
  
  // Varsayılan olarak bugünü değil, turnuvanın açılış gününü seçili tutalım (Örn: 11 Haziran 2026)
  // Turnuva başladığında bunu DateTime.now() yapabilirsin.
  DateTime _selectedDate = DateTime(2026, 6, 11); 

  // Kaydırıcı için 30 günlük bir tarih listesi oluşturalım
  late List<DateTime> _dateList;

  @override
  void initState() {
    super.initState();
    _generateDateList();
    _fetchData();
  }

  void _generateDateList() {
    // 11 Haziran 2026'dan itibaren 30 günlük bir takvim
    DateTime startDate = DateTime(2026, 6, 11);
    _dateList = List.generate(30, (index) => startDate.add(Duration(days: index)));
  }

  Future<void> _fetchData() async {
    final fixtures = await ApiService.getAllFixtures();
    setState(() {
      _allFixtures = fixtures;
      _isLoading = false;
    });
  }

  // Seçili güne göre maçları filtreleyen fonksiyon
  List<dynamic> get _filteredFixtures {
    String selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return _allFixtures.where((fixture) {
      String fixtureDate = fixture['utcDate'].toString().substring(0, 10);
      return fixtureDate == selectedDateString;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21), // Derin siber uzay mavisi
      appBar: AppBar(
        title: const Text('WC 2026 LIVE', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDateScroller(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
                : _buildFixturesList(),
          ),
        ],
      ),
    );
  }

  // Yatay Neon Tarih Kaydırıcı Modülü
  Widget _buildDateScroller() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dateList.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          DateTime date = _dateList[index];
          bool isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.cyan.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.cyan : Colors.transparent,
                  width: 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)
                ] : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MMM').format(date).toUpperCase(),
                    style: TextStyle(color: isSelected ? Colors.cyan : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Alt Kısım: Cam Efektli (Glassmorphism) Maç Listesi
  Widget _buildFixturesList() {
    final dailyMatches = _filteredFixtures;

    if (dailyMatches.isEmpty) {
      return Center(
        child: Text(
          'Bu tarihte maç bulunmuyor.\nFikstür için takvimi kaydırın.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: dailyMatches.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        var match = dailyMatches[index];
        
        // UTC tarihini yerel saate çevirip sadece saat-dakika olarak formatlıyoruz
        DateTime localTime = DateTime.parse(match['utcDate'].toString()).toLocal();
        String formattedTime = DateFormat('HH:mm').format(localTime);

        // Maç kartı tasarımı
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  match['homeTeam']['shortName'] ?? match['homeTeam']['name'] ?? 'TBD', 
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.left,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('VS', style: TextStyle(color: Color(0xFFFF00FF), fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.cyan,
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  match['awayTeam']['shortName'] ?? match['awayTeam']['name'] ?? 'TBD', 
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
