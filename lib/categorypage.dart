import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:walqimg/spicepowder.dart';

import 'Flourpage.dart';
import 'Milkpowderpage.dart';
import 'Productspecpage.dart';
import 'Pulsespage.dart';
import 'Ricepage.dart';
import 'Spicepage.dart';
import 'Sugarpage.dart';
import 'oilpage.dart';
import 'onboardscreen.dart';
import 'otherproducts.dart';

class catgrypg extends StatefulWidget {
  const catgrypg({super.key});

  @override
  State<catgrypg> createState() => _catgrypgState();
}

class _catgrypgState extends State<catgrypg> {
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    List<String> img = [
      "assets/images/categoryimg/rice.jpg",
      "assets/images/categoryimg/sugar.jpg",
      "assets/images/categoryimg/flours.jpg",
      "assets/images/categoryimg/spices.jpg",
      "assets/images/categoryimg/Spicepowder.jpg",
      "assets/images/categoryimg/pulses.jpg",
      "assets/images/categoryimg/oil.jpg",
      "assets/images/categoryimg/milkpowder.jpg",
      "assets/images/categoryimg/otheritems.jpg",
      "assets/images/categoryimg/productspec.jpg"
    ];
    List<String> txt = [
      "RICE",
      "SUGAR&JAGGERY",
      "FLOUR",
      "WHOLE SPICES",
      "SPICE POWDERS",
      "PULSES",
      "OIL",
      "MILK POWDER",
      "OTHER PRODUCTS",
      "PRODUCTS SPEC"
    ];
    List<Widget> pages = [
      const Ricepg(),
      const Sugarpg(),
      const Flourpg(),
      const Spicepg(),
      const Spicepowderg(),
      const Pulsespg(),
      const Oilimgpg(),
      const MPpg(),
      const Oppg(),
      const Prospecpg()
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.orangeAccent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  await _logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => onbrdscrn()));
                },
                icon: Icon(Icons.logout))
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => onbrdscrn()));
              },
              icon: Icon(Icons.arrow_back)),
          title: const Text(
            'Products Category',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 15,
            ),
            itemCount: img.length,
            itemBuilder: (context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pages[index]),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(img[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          txt[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
