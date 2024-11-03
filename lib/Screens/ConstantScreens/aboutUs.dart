import 'package:flutter/material.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/routes.dart';

class AboutToplinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [mainColor, secColor, terColor],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: mainColor,
        title: Row(children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.drawer);
              },
              child: Center(
                child: Image.asset(
                  "assets/back-arrow.png",
                  scale: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: const Text(
              "About Us",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Who We Are ?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Topline IT Solutions is a well-known name in the field of providing comprehensive clinic software and IT infrastructure services globally. Based in Dubai, UAE, we cater to both small startups and large organizations across diverse industries.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Our Mission',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'At Topline IT Solutions, we are committed to understanding the specific business and technological needs of our clients. We strive to offer the best clinic software solutions that meet their individual requirements and enhance their business operations.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Our Vision',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Our vision is to become global leaders in providing technology-driven business solutions and services. We aim to achieve this while maintaining integrity and delivering exceptional value to our clients through ethical and strategic clinic software solutions.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Based in Dubai, UAE, Topline IT Solutions serves clients globally with a broad geographic reach.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'For inquiries and more information, please contact us at:',
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: info@toplineuae.com\n',
              style: TextStyle(fontFamily: 'Courier'),
            ),
          ],
        ),
      ),
    );
  }
}
