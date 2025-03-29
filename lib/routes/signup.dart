import 'package:flutter/material.dart';
import 'package:moveasy/utils/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String pass = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Moveasy',
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ),
          child: Center(
              child: Padding(padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign Up", style: TextStyle(fontSize: 50, color: AppColors.textColor),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("New User? Register ", style: TextStyle(fontSize: 20, color: AppColors.textSecondaryColor),),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text("here. ", style: TextStyle(fontSize: 20, color: AppColors.textSecondaryColor, decoration: TextDecoration.underline, decorationColor: Colors.grey, decorationThickness: 3),),

                          )
                        ],
                      ),
                      Padding(padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            label: SizedBox(
                              width: 100,
                              child: Row(
                                children: [Icon(Icons.email), Text('Email')],
                              ),
                            ),
                            fillColor: AppColors.textSecondaryColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      Padding(padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            label: SizedBox(
                              width: 100,
                              child: Row(
                                children: [Icon(Icons.key), Text('Password')],
                              ),
                            ),
                            fillColor: AppColors.textSecondaryColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),

                      Padding(padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(onPressed: () {},
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.buttonColor),

                              padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                              minimumSize: WidgetStateProperty.all(Size(double.infinity, 50))
                          ),
                          child: Text("Sign up", style: TextStyle(color: AppColors.textSecondaryColor, fontSize: 30),),)
                        ,
                      )
                    ],
                  )
              )
          ),
        )
    );
  }
}
