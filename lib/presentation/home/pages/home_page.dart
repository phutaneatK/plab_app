import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plab_app/core/router/app_routes.dart';
import 'package:plab_app/presentation/nasa/pages/nasa_history_page.dart';
import 'package:plab_app/presentation/chat/pages/chat_page.dart';
import 'package:plab_app/core/services/auth_service.dart';
import 'package:plab_app/presentation/pm25/pages/pm25_history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  final Map<int,String> _pageTitles = {
    0: 'NASA History',
    1: 'Chat',
    2: 'PM 2.5',
  };
  final List<Widget> _pages = const [
    NasaHistoryPage(),
    ChatPage(),
    Pm25HistoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    // แสดง dialog ยืนยันก่อน logout
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      // ลบ token
      await _authService.deleteToken();
      // กลับไปหน้า login และลบ history ทั้งหมด
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]!),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'NASA History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'PM 2.5',
          ),
        ],
      ),
    );
  }
}
