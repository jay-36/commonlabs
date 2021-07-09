import 'package:email_launcher/email_launcher.dart';
import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Theme.dart';

class EmailDemo extends StatefulWidget {
  @override
  _EmailDemoState createState() => _EmailDemoState();
}

class _EmailDemoState extends State<EmailDemo> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController toController = new TextEditingController();
  TextEditingController ccController = new TextEditingController();
  TextEditingController bccController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  TextEditingController composeController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    toController.dispose();
    ccController.dispose();
    bccController.dispose();
    subjectController.dispose();
    composeController.dispose();
    super.dispose();
  }

  void launchEmail() async {
    List<String> to = toController.text.split(',');
    List<String> cc = ccController.text.split(',');
    List<String> bcc = bccController.text.split(',');
    String subject = subjectController.text;
    String compose = composeController.text;

    Email email =
        Email(to: to, cc: cc, bcc: bcc, subject: subject, body: compose);
    await EmailLauncher.launch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email"),
        centerTitle: true,
      ),
      body: Container(
          child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
              child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: toController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    validator: toValidator,
                    decoration: InputDecoration(
                      hintText: "To",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: ccController,
                    style: TextStyle(fontSize: 20),
                    validator: ccValidator,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Cc",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: bccController,
                    style: TextStyle(fontSize: 20),
                    validator: bccValidator,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Bcc",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: subjectController,
                    style: TextStyle(fontSize: 20),
                    validator: subjectValidator,
                    decoration: InputDecoration(
                      hintText: "Subject",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: composeController,
                    style: TextStyle(fontSize: 20),
                    validator: composeValidator,
                    decoration: InputDecoration(
                      hintText: "Compose Email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ],
            ),
          )),
          Positioned(
              bottom: 20,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (toController.text != null &&
                        ccController.text != null &&
                        subjectController.text != null &&
                        composeController.text != null) {
                      launchEmail();
                    }
                  }
                },
                child: Container(
                  width: 120,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xFF64ffda),
                      borderRadius: BorderRadius.circular(100)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Send",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.send,
                        color: Colors.black,
                        size: 25,
                      )
                    ],
                  ),
                ),
              ))
        ],
      )),
    );
  }
}

String toValidator(val) {
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!emailValid.hasMatch(val)) {
    return "Example : jaylukhi@gmail.com";
  } else {
    return null;
  }
}

String bccValidator(val) {
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!emailValid.hasMatch(val)) {
    return "Example : jaylukhi36.@gmail.com";
  } else {
    return null;
  }
}

String ccValidator(val) {
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (!emailValid.hasMatch(val)) {
    return "Example : jay.lukhi.36@gmail.co";
  } else {
    return null;
  }
}

String subjectValidator(val) {
  if (val.isEmpty) {
    return "\u24E7 Subject is empty";
  } else {
    return null;
  }
}

String composeValidator(val) {
  if (val.length < 8) {
    return "\u24E7 at Least 8 char";
  } else {
    return null;
  }
}
