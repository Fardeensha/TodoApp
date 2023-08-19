import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:todo_firbase/service/Authservice.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  int start = 30;
  bool wait = false;
  String buttonname = "Send";
  TextEditingController phonecontroller = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdfinal = ''; 
  String smsCode = ''; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextField(
                  decoration: InputDecoration(
                iconColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                hintText: 'Enter your Phone number',
                prefixIcon: const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 13.0, horizontal: 19.0),
                  child: Text(
                    '(+91)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                suffixIcon:  Padding(
                  padding:
                    const  EdgeInsets.symmetric(vertical: 13.0, horizontal: 19.0),
                  child: InkWell(
                    onTap:wait
                    ?null 
                    : ()async{
                  startTimer();
                  setState(() {
                    start = 30;
                    wait = true;
                    buttonname = "Resend";
                  });
                  await authClass.verifyPhoneNumber("+91${phonecontroller.text}", context,setData);
                  },
                    child: Text(
                      buttonname,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: wait ? Colors.grey: Colors.white),
                    ),
                  ),
                ),
              )),
            const  SizedBox(
                height: 20,
              ),
            SizedBox(
              width: MediaQuery.of(context).size.width ,
              child: Row(
                children: [
                  Expanded(child: Container(
                    height: 1,
                    color: Colors.grey,
                  )),
                const  Text('enter 5 digit otp',style: TextStyle(fontSize: 17,color: Colors.white),),
                Expanded(child: Container(
                    height: 1,
                    color: Colors.grey,
                  )),
                ],
              ),

            ),
          const  SizedBox(height: 20),
               OTPTextField(
                otpFieldStyle: OtpFieldStyle(
                  backgroundColor:const Color.fromARGB(255, 58, 39, 39)
                ),
                  length: 5,                 
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 50,
                  style:const TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                    setState(() {
                      smsCode = pin;
                    });
                  },                  
                ),
              const SizedBox(height: 20,),
             RichText(text: 
             TextSpan(
              children: [
              const  TextSpan(
                  text: "Sent OTP in ",style: TextStyle(color: Colors.yellowAccent,fontSize: 17),
                ),
                TextSpan(
                  text: "00:$start",style:const TextStyle(fontSize: 17),
                ),
              const  TextSpan(
                  text: "sec",style: TextStyle(color: Colors.yellowAccent,fontSize: 17),
                )
              ],
             )),
           const  SizedBox(height: 200,),
             ElevatedButton(onPressed: (){
              authClass.signInwithPhoneNumber(verificationIdfinal, smsCode, context);
             },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
              child: const Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Text('Lets Go'),
              ),
            ),
              
            ],
          ),
        ),
      ),
    );
  }

  void startTimer(){
  const onsec = Duration(seconds: 1);
  // ignore: unused_local_variable
  Timer timer = Timer.periodic(onsec, (timer) {
  if(start == 0){
   setState(() {
     timer.cancel();
     wait = false;
   });
  }else{
    setState(() {
      start --;
    });
  }
   });
  }
  void setData(String verificationId){
    setState(() {
       verificationIdfinal = verificationId;
    });
    startTimer();
   
  }
}
