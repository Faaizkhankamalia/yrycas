import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yrycash/auth/login.dart';
import 'package:yrycash/common/common_textfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:yrycash/model/applied_mode.dart';
import 'package:yrycash/res/static_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController moneyRequest = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController sirName = TextEditingController();
  TextEditingController securityNumber = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController homeCountry = TextEditingController();
  TextEditingController telephoneNumber = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? fDOB, fDate;
  bool isLoading = false;

  final stroage = FlutterSecureStorage();
  SharedPreferences? preferences;
  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      preferences = value;
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        title: const Text("YRY CASH"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CommonTextFieldWithTitle(
                    'Money Req', 'How much money do you request', moneyRequest,
                    (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle(
                    'User Name', 'Enter User Name', userName, (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle('Sir Name', 'Enter Sir Name', sirName,
                    (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle(
                    'Security', 'Enter social security number', securityNumber,
                    (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    selectDate(context, 0);
                  },
                  child: CommonTextFieldWithTitle(
                      'DOB', 'Enter your Date of birth', dob,
                      enabled: false,
                      suffixIcon:
                          const InkWell(child: Icon(Icons.arrow_drop_down)),
                      (val) {
                    if (val!.isEmpty) {
                      return 'This is required field';
                    }
                  }),
                ),
                const SizedBox(
                  height: 14,
                ),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    selectDate(context, 1);
                  },
                  child: CommonTextFieldWithTitle(
                      'Date', 'Date last time in USA', date,
                      enabled: false,
                      suffixIcon: const Icon(Icons.arrow_drop_down), (val) {
                    if (val!.isEmpty) {
                      return 'This is required field';
                    }
                  }),
                ),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle(
                    'Home Country', 'Enter name of Home Country', homeCountry,
                    (val) {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 14,
                ),
                CommonTextFieldWithTitle('Telephone No',
                    'Enter your telephone number', telephoneNumber, inputType: TextInputType.phone,
                        (val)
                    {
                  if (val!.isEmpty) {
                    return 'This is required field';
                  }
                }),
                const SizedBox(
                  height: 15,
                ),
                isLoading
                    ? Center(
                        child: SizedBox(
                            width: 80,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballBeat,
                                colors: [
                                  Theme.of(context).primaryColor,
                                ],
                                strokeWidth: 2,
                                pathBackgroundColor:
                                    Theme.of(context).primaryColor)),
                      )
                    : buttonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  selectDate(BuildContext context, int index) async {
    DateTime? selectDate;
    await DatePicker.showDatePicker(context,
        showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
      selectDate = date;
    }, currentTime: DateTime.now());
    if (selectDate != null) {
      setState(() {
        if (index == 0) {
          dob.text = DateFormat('dd/MM/yyyy').format(selectDate!);
          fDOB = selectDate;
        }
        if (index == 1) {
          date.text = DateFormat('dd/MM/yyyy').format(selectDate!);
          fDate = selectDate;
        }
      });
    }
  }

  Widget buttonWidget() {
    return ButtonTheme(
      height: 47,
      minWidth: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
             applyForLoan();



          }
        },
        child: const Text(
          'Apply',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );

  }

  Widget buttonLogoutWidget() {
    return ButtonTheme(
      height: 47,
      minWidth: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          await stroage.delete(key: "uid");
          Navigator.pushAndRemoveUntil(
              context,
               MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
        },
        child: const Text(
          'LogOut',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName:  Text(

                preferences?.getString('user') ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(
                '',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: Column(
            children: [

            ],
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buttonLogoutWidget(),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  applyForLoan() async {
    isLoading = true;
    setState(() {});
    int id = DateTime.now().millisecondsSinceEpoch;
    ApplicationModel dataModel = ApplicationModel(
      moneyReq: moneyRequest.text,
      userName: userName.text,
      srName: sirName.text,
      country: homeCountry.text,
      securityNumber: securityNumber.text,
      dateOfBirth: dob.text,
      date: date.text,
      telephoneNumber: telephoneNumber.text,
    );
    try {
      await FirebaseFirestore.instance
          .collection(StaticInfo.application)
          .doc('$id')
          .set(dataModel.toJson());
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Applied successfully');
      showDialogForAppllied();

    } catch (e) {
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Some error occurred');
    }
  }
  showDialogForAppllied(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 213,
            child: Column(
              children: [
                Image.asset("images/cng1.png"),
                const SizedBox(
                  height: 5,
                ),
                const     Text("your application is submitted",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                const SizedBox(
                  height: 13,
                ),
                Container(
                  child: const Text(
                    "Thankyou for choosing us, in 10 days you will recive a"
                        " confirmation of your request .Remember to be attentive to your email"
                        "where you will recive all information",textAlign: TextAlign.center,style: TextStyle( fontWeight: FontWeight.w500),),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Close",style: TextStyle(color: Colors.red),),
              onPressed: () {
                moneyRequest.text="";
                userName.text="";
                sirName.text="";
                securityNumber.text="";
                dob.text="";
                date.text="";
                homeCountry.text="";
                telephoneNumber.text="";
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

}
