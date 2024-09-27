import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:uber/authentication/sign_up_page.dart';
import 'package:uber/global/global_var.dart';
import 'package:uber/widgets/loading_dialog.dart';

import '../methods/common_method.dart';
import '../pages/home_page.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailTextEditingController =TextEditingController();
  TextEditingController PasswordTextEditingController =TextEditingController();
  @override

  CommonMethods cMethods = CommonMethods();
  checkInternetConnection()
  {
    cMethods.checkConnectivity(context as BuildContext);

    sign_In_Formvalidation();
  }

  sign_In_Formvalidation()
  {
    //.trim = remove extra spaces


    if(!emailTextEditingController.text.trim().contains("@gmail.com"))
    {
      cMethods.displaySnackBar("Please enter a correct mail ID!", context);
    }
    else if(PasswordTextEditingController.text.trim().length<5)
    {
      cMethods.displaySnackBar("Your Password should be greater than the 6 or more characters!", context);
    }
    else
    {
      sign_in_User();
    }
  }

  sign_in_User() async
  {
      showDialog(context: context, 
          barrierDismissible: false,
          builder: (BuildContext context) => LoadingDialog(
              messageText: "Allowing you in In...")
      );
      final User? userFirebase=(await FirebaseAuth.instance.signInWithEmailAndPassword(email:
      emailTextEditingController.text.trim(),
          password: PasswordTextEditingController.text.trim()
      ).catchError((errorMsg)
      {
        cMethods.displaySnackBar(errorMsg.toString(), context);
      })
      ).user;
// for close the Dialog Boxx...
      if(!context.mounted) return;

      Navigator.pop(context);
      if(userFirebase !=null)
        {
          DatabaseReference userRef = FirebaseDatabase.instance.ref().
          child("users").child(userFirebase!.uid);
          userRef.once().then((snap)
          {
            if(snap.snapshot.value !=null) {
              if ((snap.snapshot.value as Map)["blockStatus"] == "no")
              {
                userName = (snap.snapshot.value as Map)["name"];
                Navigator.push(context, MaterialPageRoute(builder: (c)=>HomePage()));
              }
              else
              {
                FirebaseAuth.instance.signOut();
                cMethods.displaySnackBar("You are Blocked. "
                    "Contact admin: arpanyeole2121@gmail.com", context);
              }

            }
            else
              {
                FirebaseAuth.instance.signOut();
                cMethods.displaySnackBar("Your record do not exist as User", context);
              }
          });
        }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [

              Image.asset(
                "assets/images/logo.png",
              ),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              //text aapn create kelet + sign up button
              Padding(
                  padding:const EdgeInsets.all(15),
                  child:Column(
                      children:[

                        const SizedBox(height: 12,),
                        TextField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "User Email",
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "User Name",
                            hintStyle: TextStyle(),
                          ),
                          style: const TextStyle(
                            color:
                            Colors.grey,
                            fontSize: 15,
                          ),
                        ),//mail id
                        const SizedBox(height: 12,),
                        TextField(
                          controller: PasswordTextEditingController,
                          obscureText: true,// for dot representaion
                          keyboardType: TextInputType.emailAddress,//taking input from here
                          decoration: InputDecoration(
                            labelText: "User Password",
                            labelStyle: TextStyle(
                              fontSize: 14,
                            ),
                            hintText: "User Password",
                            hintStyle: TextStyle(),
                          ),
                          style: const TextStyle(
                            color:
                            Colors.grey,
                            fontSize: 15,
                          ),
                        ),//password
                        const SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: ()
                          {
                            checkInternetConnection();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: EdgeInsets.symmetric(horizontal: 80,vertical: 10),
                          ),
                          child:  const Text(
                              "login"
                          ),
                        ),

                        //textButton

                      ]
                  )
              ),
              const SizedBox(height: 15,),
              TextButton(
                  onPressed:()
                  {
                    Navigator.push(context,MaterialPageRoute(builder: (c)=>SignUpScreen()));
                  },
                  child: Text(
                    "Dont'\t have an Account? Register Here",
                    style: TextStyle(
                      color:Colors.white,
                    ),
                  )

              ),
            ],
          ),
        ),
      ),
    );
  }
}
