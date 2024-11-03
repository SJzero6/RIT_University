import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Animation/Animation.Dart';
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Model/appoinmentData.dart';
import 'package:rituniversity/Model/updateSlotModel.dart';
import 'package:rituniversity/Provider/appoinmentProvider.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/timeslotProvider.dart';

class Appoinment extends StatefulWidget {
  Appoinment({super.key});

  @override
  State<Appoinment> createState() => _AppoinmentState();
}

class _AppoinmentState extends State<Appoinment>
    with SingleTickerProviderStateMixin {
  DateTime? filterDate;
  bool loading = false;
  List<AppoinmentData> data = [];
  List<AppoinmentData> filteredData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      AppointmentProvider appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);

      setState(() {
        loading = true;
      });

      List<AppoinmentData> obj = await appointmentProvider.getAppoinmentTest(
          authProvider, viewAppoinment + authProvider.userId.toString());

      setState(() {
        data = obj.reversed.toList(); // Show new appointments at the top
        filteredData = data;
        loading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.orange, // Change the color here
                  onPrimary: Colors.white, // Text color
                  onSurface: Colors.black, // Date numbers color
                ),
                dialogBackgroundColor: terColor, // Background color
              ),
              child: child!);
        });

    if (pickedDate != null && pickedDate != filterDate) {
      setState(() {
        filterDate = pickedDate;
        _filterAppointments();
      });
    }
  }

  void _filterAppointments() {
    if (filterDate == null) {
      filteredData = data;
    } else {
      filteredData = data.where((appointment) {
        // ignore: unnecessary_null_comparison
        if (appointment.appoinmentDate != null) {
          // Parse AppointmentDate into DateTime
          DateTime appointmentDateTime = DateTime.parse(appointment
                  .appoinmentDate
                  .split('/')
                  .reversed
                  .join() // Reformat to yyyy-MM-dd
              );

          // Compare dates (ignore time)
          return appointmentDateTime.year == filterDate!.year &&
              appointmentDateTime.month == filterDate!.month &&
              appointmentDateTime.day == filterDate!.day;
        }
        return false; // Handle cases where AppoinmentDate is null
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          toolbarHeight: 80,
          backgroundColor: mainColor,
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 1),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.drawer);
                  },
                  child: Center(
                    child: Image.asset(
                      "assets/back-arrow.png",
                      scale: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Container(
                margin: const EdgeInsets.only(top: 1),
                child: Text(
                  "Appointments",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.02,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.calendar_month_outlined,
                    color: Colors.white),
                onPressed: () => _selectDate(context),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                        strokeWidth: 6,
                      ),
                    )
                  : FadeAnimation(
                      0.5,
                      DoctorAppointmentList(
                          obj: filteredData,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth)),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorAppointmentList extends StatefulWidget {
  const DoctorAppointmentList({
    super.key,
    required this.obj,
    required this.screenHeight,
    required this.screenWidth,
  });

  final List<AppoinmentData> obj;
  final double screenHeight;
  final double screenWidth;

  @override
  State<DoctorAppointmentList> createState() => _DoctorAppointmentListState();
}

class _DoctorAppointmentListState extends State<DoctorAppointmentList> {
  bool _isPastAppointment(String date, String time) {
    try {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
      DateFormat timeFormat = DateFormat('HH:mm');

      DateTime parsedDate = dateFormat.parse(date);
      DateTime parsedTime = timeFormat.parse(time);

      DateTime appointmentDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      return appointmentDateTime.isBefore(DateTime.now());
    } catch (e) {
      print('Error parsing date or time: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast),
      itemCount: widget.obj.length,
      itemBuilder: (context, index) {
        String time24 = widget.obj[index].appointmentTime.toString();
        DateFormat dateFormat24 = DateFormat("HH:mm");
        DateFormat dateFormat12 = DateFormat("hh:mm a");

        DateTime dateTime = dateFormat24.parse(time24);
        String time12hrFormat = dateFormat12.format(dateTime);

        bool isPast = _isPastAppointment(widget.obj[index].appoinmentDate,
            widget.obj[index].appointmentTime.toString());
        Color cardColor = isPast ? Colors.grey[300]! : Colors.white;
        Color textColor = isPast ? Colors.grey : Colors.black;
        Color dNameColor = isPast ? Colors.grey : mainColor;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.screenHeight * 0.01,
            horizontal: widget.screenWidth * 0.02,
          ),
          child: Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.screenHeight * 0.02),
            ),
            elevation: 8,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: widget.screenWidth * 0.02),
                        child: CircleAvatar(
                          backgroundColor: contcolor,
                          radius: widget.screenHeight * 0.05,
                          foregroundImage: const AssetImage('assets/rit.png'),
                        ),
                      ),
                      SizedBox(width: widget.screenWidth * 0.03),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.obj[index].doctorName}',
                              style: TextStyle(
                                fontSize: widget.screenHeight * 0.02,
                                color: dNameColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "${widget.obj[index].doctorDepartment}",
                              style: TextStyle(
                                fontSize: widget.screenHeight * 0.018,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: widget.screenHeight * 0.01),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: dNameColor,
                                  size: widget.screenHeight * 0.02,
                                ),
                                SizedBox(width: widget.screenWidth * 0.02),
                                Text(
                                  widget.obj[index].appoinmentDate,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: widget.screenHeight * 0.018,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: widget.screenHeight * 0.01),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: dNameColor,
                                  size: widget.screenHeight * 0.02,
                                ),
                                SizedBox(width: widget.screenWidth * 0.02),
                                Text(
                                  time12hrFormat,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: widget.screenHeight * 0.018,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isPast)
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          AuthProvider authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          int doctorId = authProvider.docId;
                          _selectDate(context, doctorId);
                        },
                        child: Container(
                          height: widget.screenHeight * 0.08,
                          width: widget.screenWidth * 0.12,
                          decoration: const BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10)),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.update,
                              color: Colors.white,
                              size: widget.screenHeight * 0.03,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _confirmDelete(context, widget.obj[index]),
                        child: Container(
                          width: widget.screenWidth * 0.12,
                          height: widget.screenHeight * 0.08,
                          decoration: const BoxDecoration(
                            color: terColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: widget.screenHeight * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, AppoinmentData appointment) {
    TextEditingController cancelReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: contcolor,
          title: const Text('Confirm Cancellation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Are you sure you want to cancel this appointment?'),
              const SizedBox(height: 10),
              TextFormField(
                controller: cancelReasonController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: mainColor)),
                  hintText: 'Cancellation Reason',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: mainColor),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: mainColor),
              ),
            ),
            TextButton(
              onPressed: () {
                if (cancelReasonController.text.isNotEmpty) {
                  _cancelAppointment(
                      context, appointment, cancelReasonController.text);
                  Navigator.of(context).pop();
                  showTextSnackBar(
                      context, 'Your Appoinmet Deleted Successfully');
                } else {
                  showTextSnackBar(context, 'This Feild Can\'t Be Empty');
                }
              },
              child: const Text('Cancel Appointment',
                  style: TextStyle(color: mainColor)),
            ),
          ],
        );
      },
    );
  }

  void _cancelAppointment(
      BuildContext context, AppoinmentData appointment, String cancelReason) {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    appointmentProvider
        .cancelAppointment(appointment.appointmentId.toString(), cancelReason)
        .then((_) {
      // Handle success, e.g., remove item from local list
      setState(() {
        widget.obj.remove(
            appointment); // Ensure widget.obj is synchronized with the provider
      });
    }).catchError((error) {
      // Handle error
      print('Failed to cancel appointment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to cancel appointment')),
      );
    });
  }

  void _selectDate(BuildContext context, int doctorId) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      String selectedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _showSlotPicker(context, selectedDate, doctorId);
    }
  }

  void _showSlotPicker(
      BuildContext context, String selectedDate, int doctorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final provider = Provider.of<TimeslotProvider>(context);
        return FutureBuilder<UpdateTimeSlot>(
          future: provider.updateFetchTimeSlots(
              '${selectedDate}T00:00:00', '${selectedDate}T23:45:00', doctorId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: mainColor,
              ));
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to load time slots: ${snapshot.error}'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            } else if (snapshot.hasData) {
              final timeSlots = snapshot.data!.time;
              if (timeSlots.isEmpty) {
                return AlertDialog(
                  title: const Text(
                    'No Slots Available',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  content: const Text(
                      'There are no available time slots for the selected date.'),
                  actions: [
                    TextButton(
                      child:
                          const Text('OK', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              } else {
                return AlertDialog(
                  title: const Text('Select a Time Slot'),
                  content: SizedBox(
                    height: 300,
                    width: 300,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 5,
                        childAspectRatio: 2,
                      ),
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = timeSlots[index];
                        return GestureDetector(
                          onTap: () {
                            final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false);
                            String time = slot.trim();

                            String convertTo24Hour(
                              String time12Hour,
                            ) {
                              // Split hour and minute
                              final timeComponents = time12Hour.split(':');
                              int hour = int.parse(timeComponents[0]);
                              final minute = timeComponents[1];

                              //Convert hour based on AM/PM

                              // Format hour and minute into 24-hour format
                              String hour24 = hour.toString().padLeft(2, '0');
                              return '$hour24:$minute';
                            }

                            String time24Hour = convertTo24Hour(time);

                            _updateAppointment(
                              context,
                              authProvider.appointId.toString(),
                              '$selectedDate $time24Hour',
                              doctorId.toString(),
                              authProvider.userId.toString(),
                            );
                            print(
                                "$selectedDate $time:00${doctorId}sooraj${authProvider.appointId}");
                          },
                          child: Card(
                            color: Colors.orange,
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  slot,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
            } else {
              return AlertDialog(
                title: const Text('No Slots Available',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                content: const Text(
                    'There are no available time slots for the selected date.'),
                actions: [
                  TextButton(
                    child:
                        const Text('OK', style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _updateAppointment(
      BuildContext context,
      String appointmentId, // Added this argument
      String dateTimeSlot,
      String doctorId,
      String patientId) {
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    // Construct the date-time slot
    final selectedDateAndSlot = '$dateTimeSlot';

    appointmentProvider
        .updateAppointmentSlot(
      appointmentId,
      selectedDateAndSlot,
      doctorId,
      patientId,
    )
        .then((_) {
      //Navigator.pop(context);
      Navigator.popAndPushNamed(context, AppRoutes.viewAppoinments);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Appointment updated successfully')),
      // );
      _showSplashDialog();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update appointment')),
      );
    });
  }

  void _showSplashDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: contcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 150,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: mainColor,
                  ),
                  SizedBox(height: 20),
                  Text("Your Appoinment is Updated"),
                ],
              ),
            ),
          );
        },
      );

      // Dismiss the dialog after 3 seconds
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    });
  }
}
