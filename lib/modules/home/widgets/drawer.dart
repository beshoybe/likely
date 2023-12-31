import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grad/modules/home/provider/home_provider.dart';
import 'package:grad/modules/home/widgets/header.dart';
import 'package:grad/routes.dart';

class HomeDrawer extends ConsumerStatefulWidget {
  const HomeDrawer({super.key});

  @override
  ConsumerState<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends ConsumerState<HomeDrawer> {
  double? balance;
  @override
  void initState() {
    getBalace();
    super.initState();
  }

  void getBalace() async {
    final res = await ref.read(homeProvider.notifier).getUserBalance();
    setState(() {
      balance = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const HomeHeader(
              showMenu: false,
            ),
            balanceWidget(balance),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.login, (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget balanceWidget(double? b) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: b == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('Balance'),
                    Text('$b EGP'),
                  ],
                ),
              ),
      ),
    );
  }
}
