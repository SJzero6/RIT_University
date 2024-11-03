import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Animation/Animation.Dart';
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Model/doctorProfile.dart';
import 'package:rituniversity/Provider/apiProviders.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/bookingProvider.dart';
import 'package:rituniversity/Provider/timeslotProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  String? selectedSlotTime;
  String? selectedSlotPeriod;
  List<String> lockedSlots = [];
  Map<DateTime, List<String>> lockedSlotsMap = {};

  final List<DateTime> days =
      List.generate(365, (index) => DateTime.now().add(Duration(days: index)));

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    _fetchDoctorData();
    _loadProfileImage();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchTimeslots();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _fetchTimeslots() async {
    final provider = Provider.of<TimeslotProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDay);

    await provider.fetchTimeslots("${selectedDateString}T00:00:00",
        "${selectedDateString}T23:45:00", authProvider.docId.toString());
  }

  void _fetchDoctorData() async {
    final apiService = Provider.of<ApiService>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    List<DoctorData> data =
        await apiService.getDoctorData(authProvider, doctorsAPI);

    setState(() {
      doctorData = data;
    });
  }

  List<DoctorData> doctorData = [];

  void _lockSlot(String slot) {
    setState(() {
      if (!lockedSlotsMap.containsKey(_selectedDay)) {
        lockedSlotsMap[_selectedDay] = [];
      }

      lockedSlotsMap[_selectedDay]!.add(slot);
    });

    Future.delayed(const Duration(days: 1), () {
      setState(() {
        lockedSlotsMap[_selectedDay]!.remove(slot);
      });
    });
  }

  bool _isSlotLocked(String slot) {
    if (lockedSlotsMap.containsKey(_selectedDay)) {
      return lockedSlotsMap[_selectedDay]!.contains(slot);
    }
    return false;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imagePath = pickedFile.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', imagePath);

      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');

    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimeslotProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        toolbarHeight: 100,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [mainColor, secColor, terColor],
            ),
          ),
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              'assets/rit.png',
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Hi.. Welcome Back\n${authProvider.username}',
                style: GoogleFonts.afacad(
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: Colors.white),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : const AssetImage('assets/user-circle-regular-240.png')
                          as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 0)
                      : null,
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FittedBox(
                        fit: BoxFit.cover,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 3, color: mainColor),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            child: Image.asset('assets/rit.png'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${doctorData.isNotEmpty ? doctorData[0].DoctorName : 'Loading...'}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${doctorData.isNotEmpty ? doctorData[0].DoctorDepartment : 'Loading...'}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text('4.5 (2530)'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Text(
                        'Schedules',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.clear_all_outlined,
                        color: mainColor,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final day = days[index];
                        bool isSelected = _selectedDay.year == day.year &&
                            _selectedDay.month == day.month &&
                            _selectedDay.day == day.day;

                        bool isToday = DateTime.now().year == day.year &&
                            DateTime.now().month == day.month &&
                            DateTime.now().day == day.day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = day;
                              _fetchTimeslots();
                            });
                          },
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        mainColor,
                                        terColor,
                                        mainColor,
                                        terColor,
                                        mainColor
                                      ],
                                    )
                                  : isToday
                                      ? const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomRight,
                                          colors: [brown, brown])
                                      : const LinearGradient(colors: [
                                          datecolor,
                                          contcolor,
                                          datecolor
                                        ]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEE').format(day),
                                    style: TextStyle(
                                        color: isSelected || isToday
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    DateFormat('d').format(day),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected || isToday
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: constraints.maxHeight * 0.07,
                    decoration: BoxDecoration(
                      border: Border.all(color: blurcolor),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [mainColor, secColor, terColor]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: mainColor,
                      tabs: const [
                        Tab(
                          child: Text(
                            "Morning",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Afternoon",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Evening",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(81, 40, 18, 0.298),
                              blurRadius: 10,
                              offset: Offset(10, 5),
                            )
                          ],
                          color: contcolor,
                          borderRadius: BorderRadius.circular(20)),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          buildTimeSlots('Morning', provider.morningSlots),
                          buildTimeSlots('Afternoon', provider.afternoonSlots),
                          buildTimeSlots('Evening', provider.eveningSlots),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: ElevatedButton(
          onPressed:
              selectedSlotTime != null && !_isSlotLocked(selectedSlotTime!)
                  ? () {
                      String selectedDateString =
                          DateFormat('yyyy-MM-dd').format(_selectedDay);
                      _handleBookingAppointment();
                      _showSplashDialog(selectedSlotTime.toString(),
                          selectedDateString, selectedSlotPeriod.toString());
                    }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: mainColor,
            shadowColor: blurcolor,
            elevation: 10,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
          child: const Text(
            'CONFIRM & BOOK NOW',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildTimeSlots(String period, List<String> slots) {
    final provider = Provider.of<TimeslotProvider>(context);
    if (slots.isEmpty) {
      return Center(
        child: Text(
          'No slots available for $period',
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: blurcolor),
        ),
      );
    } else {
      return Stack(
        children: [
          provider.loading
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: animationController
                          .drive(ColorTween(begin: mainColor, end: secColor))),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 4,
                    childAspectRatio: 2,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    final isLocked = _isSlotLocked(slot);
                    return FadeAnimation(
                      1,
                      GestureDetector(
                        onTap: () {
                          if (!isLocked) {
                            setState(() {
                              selectedSlotTime = slot;
                              selectedSlotPeriod = period;
                            });
                          }
                        },
                        child: Chip(
                          backgroundColor: isLocked
                              ? blurcolor
                              : selectedSlotTime == slot
                                  ? mainColor
                                  : Colors.white,
                          label: Text(
                            slot,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isLocked
                                  ? Colors.black
                                  : selectedSlotTime == slot
                                      ? Colors.white
                                      : mainColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }
  }

  _handleBookingAppointment() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String selectedDateString = DateFormat('yyyy-MM-dd').format(_selectedDay);
    String selectedDay = "$selectedDateString $selectedSlotTime";
    String doctorId = doctorData[0].id.toString();
    String patientId = authProvider.userId.toString();

    final response =
        await Provider.of<SlotBookingProvider>(context, listen: false)
            .bookAppointment(selectedDay, doctorId, patientId);

    if (response.statusCode == 200) {
      showTextSnackBar(
          context, 'Time slot is booked for $selectedDay\t$selectedSlotTime');
    } else if (response.statusCode == 400 &&
        response.body.contains('Time slot already booked')) {
      showTextSnackBar(context, 'Time slot already booked');
    } else {
      showTextSnackBar(context, 'Contact The clinic');
    }
  }

  void _showSplashDialog(String time, String date, String period) {
    Future.delayed(
      Duration.zero,
      () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: contcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: mainColor,
                      ),
                      const Text(
                        "Your Appoinment is booking for",
                        style: TextStyle(
                            color: mainColor, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                            color: mainColor, fontWeight: FontWeight.bold),
                      ),
                      Text("at $time $period",
                          style: const TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            });
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: contcolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  content: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.done,
                          color: mainColor,
                          size: 50,
                        ),
                        const Text(
                          "Your Appoinment is booked for",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          date,
                          style: const TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold),
                        ),
                        Text("at $time $period",
                            style: const TextStyle(
                                color: mainColor, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.viewAppoinments);
                            },
                            child: const Text('View Appoinments',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ),
                );
              });
        });
      },
    );
  }
}
