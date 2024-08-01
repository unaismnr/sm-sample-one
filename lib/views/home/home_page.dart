import 'package:flutter/material.dart';
import 'package:sm_sample_one/services/auth_service.dart';
import 'package:sm_sample_one/views/auth/login_page.dart';
import 'package:sm_sample_one/views/home/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.power_settings_new_outlined,
              ),
              title: const Text('Signout'),
              onTap: () async {
                final success = await AuthService.signOut();
                if (context.mounted) {
                  success
                      ? Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                          (route) => false,
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Signout Failed'),
                          ),
                        );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
