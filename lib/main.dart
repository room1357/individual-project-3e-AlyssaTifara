import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/logic/user_manager.dart';
import 'package:pemrograman_mobile/models/user_model.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/homescreen/profile_screen.dart';
import 'screens/homescreen/settings_screen.dart';
import 'screens/homescreen/about_screen.dart';
import 'screens/expense_list_screen.dart';
import 'screens/statistic_screen.dart';
import 'screens/message_screen.dart';
import 'screens/add_expense_screen.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/custom_fab.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final UserManager _userManager = UserManager();

  MyApp({super.key});

  // 🎨 Warna tema global
  static const Color maroonDark = Color(0xFF4B1C1A); // deep maroon elegan
  static const Color maroonLight = Color(0xFF6E2E2A); // maroon hangat
  static const Color bone = Color(0xFFE1D9CC); // krem lembut

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checkout App',
      theme: ThemeData(
        // Set primary colors so widgets like FloatingActionButton, etc. inherit nicely
        primaryColor: maroonDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: maroonDark,
          primary: maroonDark,
          secondary: maroonLight,
          surface: bone,
        ),
        scaffoldBackgroundColor: bone,
        appBarTheme: const AppBarTheme(
          backgroundColor: maroonDark,
          foregroundColor: bone,
          elevation: 4,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white), // hamburger icon white
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: maroonLight,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: maroonDark,
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(userManager: _userManager),
        '/register': (context) => RegisterScreen(userManager: _userManager),
        '/home': (context) => const MainScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about': (context) => const AboutScreen(),
        '/messages': (context) => const MessagesScreen(),
        '/add_expense': (context) => const AddExpenseScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  User? _currentUser;

  late List<Widget> _pages;

  // 🎨 Tema warna (lokal)
  static const Color maroonDark = Color(0xFF4B1C1A);
  static const Color maroonLight = Color(0xFF6E2E2A);
  static const Color bone = Color(0xFFE1D9CC);

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const ExpenseListScreen(),
      const StatisticScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = ModalRoute.of(context)?.settings.arguments as User?;
    if (user != null && user != _currentUser) {
      setState(() {
        _currentUser = user;
        _pages[2] = ProfileScreen(user: _currentUser);
      });
    }
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // 🔹 Header Drawer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [maroonDark, maroonLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage("assets/profile.jpg"),
                ),
                const SizedBox(height: 10),
                Text(
                  _currentUser?.fullName ?? "Nama User",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: bone,
                  ),
                ),
                Text(
                  _currentUser?.email ?? "user@email.com",
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // 🔹 Menu items (dengan onTap supaya bisa diklik)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.home, color: maroonDark),
                  title: const Text("Home"),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: maroonDark),
                  title: const Text("Profile"),
                  onTap: () {
                    Navigator.pop(context); // tutup drawer
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message, color: maroonDark),
                  title: const Text("Messages"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/messages');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info, color: maroonDark),
                  title: const Text("About"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: maroonDark),
                  title: const Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sudah di-theme global; kita atur judul & warna teks di sini juga
      appBar: AppBar(
        backgroundColor: maroonDark,
        title: const Text(
          "Checkout App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: bone,
          ),
        ),
        centerTitle: true,
        elevation: 4,
        // iconTheme putih sudah di ThemeData.appBarTheme, jadi hamburger akan putih
      ),
      drawer: _buildDrawer(context),

      // Halaman aktif sesuai tab
      body: _pages[_selectedIndex],

      // Tombol tambah (FAB)
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
