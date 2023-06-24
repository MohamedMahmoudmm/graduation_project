import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_on_route/login/cubit/cubit.dart';
import 'package:help_on_route/login/cubit/states.dart';
import 'package:help_on_route/map/mapScreen.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  //const VerificationScreen({Key? key}) : super(key: key);
  String? name;
  String? number;
  bool? car;
  VerificationScreen({
    required String name,
    required String num,
    required bool car
  })
  {
    this.name=name;
    this.number=num;
    this.car=car;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context)=>HelperLoginCubit(),
      child: BlocConsumer<HelperLoginCubit,HelperLoginStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state)
        {
          return SafeArea(
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30,),
                  child:SingleChildScrollView(
                    child: Column(
                      children:
                      [
                        CircleAvatar(
                          radius: 95,
                          backgroundColor: Colors.black87,
                          child: Icon(Icons.mail_outline_outlined,size: 80,color: Colors.white,),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Verification ',
                              style: TextStyle(fontSize: 32,color: Colors.black87),),
                            Text('Code',
                              style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.black),),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Text('Please type the verification code',style: TextStyle(fontSize: 20),),
                        SizedBox(height: 20,),
                        Pinput
                          (onCompleted: (code)
                        {
                          print(code);
                          HelperLoginCubit.get(context).submitOTP(code,name!,car!,context);

                          //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MapScreen()));
                        },
                          length: 6,

                          defaultPinTheme: PinTheme(
                            width: 56,

                            height: 56,
                            textStyle: TextStyle(fontSize: 20,
                                color: Color.fromRGBO(30, 60, 87, 1),
                                fontWeight: FontWeight.w600),
                            decoration: BoxDecoration(

                              border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),

                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },

      ),

    );
  }
}
