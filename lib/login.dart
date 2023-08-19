import 'package:flutter/material.dart';
import 'package:todo_firbase/main.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firbase/homepage.dart';
import 'package:todo_firbase/phoneAuth.dart';
import 'package:todo_firbase/service/Authservice.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _SignupState();
}

 
class _SignupState extends State<Login> {
   
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final  TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 53, 42, 42),
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
              const  Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const  SizedBox(height: 20,),
                TextFormField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    iconColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Emailaddress',
                  ),
                ),
              const  SizedBox(height: 20,),
                 TextFormField(
                  obscureText: true,
                  controller: _passwordcontroller,
                  decoration: const InputDecoration(
                    iconColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                  ),
                  const  SizedBox(height: 20),
                const  Text('or',style: TextStyle(
                    fontSize: 20
                  ),),
                const  SizedBox(height: 20),
                InkWell(onTap: ()async {
                  await authClass.googleSignIn(context);
                final _sharedPrefs = await SharedPreferences.getInstance();
                 await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
                },
                  child: Card(
                  elevation: 20,
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const  Text('Continue with google'),
                    const   SizedBox(width: 10,),
                     Image.asset('Assets/google.webp',width: 20,height: 40,)
                    ],
                  )),
                ),
              const  SizedBox(height: 10,),
                InkWell(
                  onTap: () async{    
                final _sharedPrefs = await SharedPreferences.getInstance();
                 await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
                     Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx1) => const PhoneAuth()));
                  },
                  child: Card(
                  elevation: 10,
                   child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    const Text('Continue with Phonenumber'),
                    const  SizedBox(width: 10,),
                      Image.asset('Assets/phone2.png',height: 40,width: 20,)
                    ],
                  )),
                ),
              const  SizedBox(height: 20),
              ElevatedButton(onPressed: ()async{
                try{
                 firebase_auth.UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword
                (email:_emailcontroller.text, password: _passwordcontroller.text);
                 print(userCredential.user!.email);
                 
                 final _sharedPrefs = await SharedPreferences.getInstance();
                 await _sharedPrefs.setBool(SAVE_KEY_NAME, true);
                 
                  setState(() {
                  circular = false;
                   // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const Homepage()), (route) => false);
                  

                });
                }
                catch(e){
                      final snackBar = SnackBar(content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   setState(() {
                   circular = false;
                });
                }
              },style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink, padding:const EdgeInsets.only(left:60,right: 60,top: 15,bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                child: Center(
                child: circular 
                 ?const CircularProgressIndicator()  
                 :const Text('Login')),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const  Text('Create  an account?'),
                  TextButton(onPressed: (){Navigator.pop(context);}, child:const Text('Sign up'))
              ],
            )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
