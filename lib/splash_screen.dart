import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black87,

        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DR',
              style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[400],

              ),
              ),
              Text('DRIVER',
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,

                ),
              ),

              IconButton(
                  onPressed: (){
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                  icon: Icon(Icons.arrow_circle_right_outlined,size: 40,color: Colors.green[400],))
            ],
          ),
        ),),
      ),
    );
  }
}
