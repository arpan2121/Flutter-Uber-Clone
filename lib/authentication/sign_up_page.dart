
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/authentication/login.dart';
import 'package:uber/methods/common_method.dart';
import 'package:uber/pages/home_page.dart';
import 'package:uber/widgets/loading_dialog.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //we need some cotrollers to get and save the the data to data base
  TextEditingController UserNameTextEditingController =TextEditingController();
  TextEditingController UserPhoneTextEditingController =TextEditingController();
  TextEditingController emailTextEditingController =TextEditingController();
  TextEditingController PasswordTextEditingController =TextEditingController();

  CommonMethods cMethods = CommonMethods();
  checkInternetConnection()
  {
      cMethods.checkConnectivity(context as BuildContext);

      signUpFormvalidation();
  }

  signUpFormvalidation()
  {
    //.trim = remove extra spaces
    if(UserNameTextEditingController.text.trim().length <3)
      {
        cMethods.displaySnackBar("Your Name Must be atleast 4 or more characters!", context);
      }
    else if(UserPhoneTextEditingController.text.trim().length ==10)
      {
        cMethods.displaySnackBar("Your Mobile Number Should Be in 10 numbers!", context);
      }
    else if(!emailTextEditingController.text.trim().contains("@gmail.com"))
      {
        cMethods.displaySnackBar("Please enter a correct mail ID!", context);
      }
    else if(PasswordTextEditingController.text.trim().length<5)
    {
      cMethods.displaySnackBar("Your Password should be greater than the 6 or more characters!", context);
    }
    else
      {
        regissterNewUser();
      }
  }
  regissterNewUser()async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>  LoadingDialog(
        messageText: "Registering your account..."
      ),
    );
    final User? userFirebase=(await FirebaseAuth.instance.createUserWithEmailAndPassword(email:
    emailTextEditingController.text.trim(), 
        password: PasswordTextEditingController.text.trim()
    ).catchError((errorMsg)
        {
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;
    if(!context.mounted) return;

    Navigator.pop(context);

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap =
        {
          "name":UserNameTextEditingController.text.trim(),
          "email":emailTextEditingController.text.trim(),
          "phone":UserPhoneTextEditingController.text.trim(),
          "ID":userFirebase.uid,
          "blockStatus": "no",
        };

    userRef.set(userDataMap);
      Navigator.push(context, MaterialPageRoute(builder: (c)=>HomePage()));


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [

              Image.asset(
                "assets/images/logo.png",
              ),
             // const SizedBox(height: 5,),
              const Text(
                "Create a User\'s Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              //text aapn create kelet + sign up button
              Padding(
                padding:const EdgeInsets.all(10),
                child:Column(
                  children:[
                    TextField(
                      controller: UserNameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                        hintText: "User Name",
                        hintStyle: TextStyle(),
                      ),
                      style: const TextStyle(
                        color:
                          Colors.grey,
                        fontSize: 15,
                      ),
                    ),//name
                    const SizedBox(height: 10,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 15,
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
                    const SizedBox(height: 10,),
                    TextField(
                      controller:UserPhoneTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "User Phone no.",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                        hintText: "User Name",
                        hintStyle: TextStyle(),
                      ),
                      style: const TextStyle(
                        color:
                        Colors.grey,
                        fontSize: 15,
                      ),
                    ),//phone number
                    const SizedBox(height: 10,),
                    TextField(
                      controller: PasswordTextEditingController,
                      obscureText: true,// for dot representaion
                      keyboardType: TextInputType.emailAddress,//taking input from here
                      decoration: InputDecoration(
                        labelText: "User Password",
                        labelStyle: TextStyle(
                          fontSize: 15,
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
                    const SizedBox(height: 10,),
                    ElevatedButton(
                      onPressed: ()
                      {
                        checkInternetConnection();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10), // left, top, right, bottom
                      ),
                      child:  const Text(
                        "Sign Up"
                      ),
                    ),

                    //textButton

                  ]
                )
              ),
              const SizedBox(height: 0.1,),
              TextButton(
                  onPressed:()
                {
                  Navigator.push(context,MaterialPageRoute(builder: (c)=>LoginScreen()));
                },
                  child: Text(
                    "Already have an account? login Here",
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
