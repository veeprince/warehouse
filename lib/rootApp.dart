// ignore_for_file: file_names

import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/authentication_viewmodel.dart.dart';
import 'package:warehouse/blocs/auth_block.dart';
import 'package:warehouse/device/screens/home.dart';
import 'package:warehouse/inventory/screens/inventory_home.dart';
import 'dishware/screens/dishware_home.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  late StreamSubscription<User?> loginStateSubscription;

  late PageController _pageController;
  @override
  void initState() {
    var authBloc = Provider.of<AuthBloc>(context, listen: false);
    loginStateSubscription = authBloc.currentUser.listen((fbUser) {
      if (fbUser == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AuthenticationScreen()));
      }
    });
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        selectedIndex: _currentIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.ease);
        }),
        items: [
          BottomNavyBarItem(
            textAlign: TextAlign.center,
            icon: const Icon(Icons.devices),
            title: const Text('Devices'),
            activeColor: Colors.grey,
          ),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: const Icon(Icons.inventory),
              title: const Text('Warehouse'),
              activeColor: Colors.grey),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: const Icon(Icons.restaurant),
              title: const Text('Dishware'),
              activeColor: Colors.grey),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: const <Widget>[
            MyHomePage(),
            InventoryHomePage(),
            DishwareHomePage(),
          ],
        ),
      ),
    );
  }
}
