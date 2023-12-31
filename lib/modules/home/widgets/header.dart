import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grad/shared/extensions.dart';

class HomeHeader extends StatelessWidget {
  final bool showMenu;
  const HomeHeader({super.key, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;

    return Row(
      children: [
        if (showMenu)
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        Expanded(
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            margin: EdgeInsets.all(context.radius(1)),
            child: Padding(
              padding: EdgeInsets.all(context.radius(1)),
              child: Row(children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://cdn3.vectorstock.com/i/1000x1000/30/97/flat-business-man-user-profile-avatar-icon-vector-4333097.jpg'),
                ),
                SizedBox(width: context.widthPercent(2)),
                Text(
                    '${!showMenu ? '' : 'Welcome'} ${authUser!.displayName ?? ''}'),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
