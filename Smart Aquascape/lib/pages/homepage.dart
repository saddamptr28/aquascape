import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/menu.dart';
import 'package:flutter_application_1/pages/settings.dart';
import 'package:flutter_application_1/util/smart_device_box.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // List alatnya
  List mySmartDevices = [
    ["Lampu ", "lib/icon/lampu.png", false],
    ["Kipas/Pendingin", "lib/icon/kipas.png", false],
    ["Pemanas", "lib/icon/suhu.png", false],
    ["Pengatur PH", "lib/icon/PH.png", false],
  ];

  int currentIndex = 0;

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }

  Widget _getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return MenuPage();
      case 2:
        return SettingsPageUI();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Selamat Datang di Smart Aquascape,"),
              Text(
                "kakak yanzy",
                style: TextStyle(fontSize: 40),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text("Alat Pintar Smart Aquascape"),
        ),

        // Ini bagian kolom atau alat pintarnya
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            children: [
              SmartDeviceBox(
                smartDeviceName: mySmartDevices[0][0],
                iconPath: mySmartDevices[0][1],
                powerOn: mySmartDevices[0][2],
                onChanged: (value) => powerSwitchChanged(value, 0),
              ),
              SmartDeviceBox(
                smartDeviceName: mySmartDevices[1][0],
                iconPath: mySmartDevices[1][1],
                powerOn: mySmartDevices[1][2],
                onChanged: (value) => powerSwitchChanged(value, 1),
              ),
              SmartDeviceBox(
                smartDeviceName: mySmartDevices[2][0],
                iconPath: mySmartDevices[2][1],
                powerOn: mySmartDevices[2][2],
                onChanged: (value) => powerSwitchChanged(value, 2),
              ),
              SmartDeviceBox(
                smartDeviceName: mySmartDevices[3][0],
                iconPath: mySmartDevices[3][1],
                powerOn: mySmartDevices[3][2],
                onChanged: (value) => powerSwitchChanged(value, 3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        color: Colors.blue,
        items: const [
          Icon(Icons.home),
          Icon(Icons.menu),
          Icon(Icons.settings),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/icon/30959.jpg"),
            fit: BoxFit.cover, // Atur agar gambar menyesuaikan ukuran layar
          ),
        ),
        child: SafeArea(
          child: _getCurrentPage(),
        ),
      ),
    );
  }
}
