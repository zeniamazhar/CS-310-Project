import 'package:flutter/material.dart';
import 'package:moveasy/utils/AppColors.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Image.asset('assets/images/logo.png'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.darkButtonColor),

                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                        ),
                        child: Text("Login", style: TextStyle(color: AppColors.darkButtonTextColor, fontSize: 30),),)
                      ,
                    ),
                    Padding(padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.darkButtonColor),

                            padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 20)),
                        ),
                        child: Text("Sign Up", style: TextStyle(color: AppColors.darkButtonTextColor, fontSize: 30),),)
                      ,
                    )
                  ],
                )
              ],
            ),
            ),
          )
        )
    );
  }
}