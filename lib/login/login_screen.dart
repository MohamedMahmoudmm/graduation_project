
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_on_route/login/cubit/cubit.dart';
import 'package:help_on_route/login/cubit/states.dart';
import 'package:help_on_route/login/verification_screen.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
var nameController=TextEditingController();

   var phoneController=TextEditingController();

   bool car=false;

   final formkey = GlobalKey<FormState>();

   String generateCountryFlag()
   {
     String countryCode='eg';
     String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
             (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0)+127397));
     return flag;
   }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(BuildContext context)=>HelperLoginCubit(),
      child:BlocConsumer<HelperLoginCubit,HelperLoginStates>(
        listener: (context,state){},
          builder:  (context,state){
          var cubit=HelperLoginCubit.get(context);
          cubit.context=context;
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Center(
                  child: Form(
                    key: formkey,
                    child: Column(

                      children: [
                        Container(
                            width: double.infinity,
                            height: 350,
                            decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(200),
                                    bottomRight:  Radius.circular(200)
                                )
                            ),

                            // radius: 100,
                            child: const Icon(
                              Icons.cable_rounded,
                              color: Colors.white,
                              size: 200,
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text('welcome to ',
                              style:  TextStyle(fontSize: 38,color: Colors.grey),),
                            Text('Helper',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                  fontSize: 40,color: Colors.black),),
                            //generateCountryFlag()
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                              cursorHeight: 27,
                              controller: nameController,
                              cursorColor:Colors.black ,
                              keyboardType: TextInputType.name,
                              validator: (value)
                              {
                                if(value!.isEmpty)
                                  {
                                    return 'enter name';
                                  }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'enter your name',
                                hintStyle: const TextStyle(
                                    fontSize: 18
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:  BorderRadius.circular(25.0),

                                    borderSide:  const BorderSide(width: 2)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:  BorderRadius.circular(25.0),

                                    borderSide:  const BorderSide(color: Colors.grey,width: 2)
                                ),


                              )
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            //autofocus: true,
                              cursorHeight: 27,
                              controller: phoneController,
                              cursorColor:Colors.black ,
                              validator: (value)
                              {
                                if(value!.isEmpty ||value.length != 11)
                                {
                                  return 'enter phone';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: '010********',

                                hintStyle: const TextStyle(
                                    fontSize: 18
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:  BorderRadius.circular(25.0),

                                    borderSide:  const BorderSide(width: 2)
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:  BorderRadius.circular(25.0),

                                    borderSide:  const BorderSide(color: Colors.grey,width: 2)
                                ),
                                prefixIcon: IconButton(
                                  onPressed: (){},
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),

                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                    activeColor: Colors.green,
                                    value: car,
                                    onChanged: (bool? value) {
                                      print('car: $value');
                                      setState(() {
                                        car = value!;

                                      });
                                    },
                                  ),
                                ),
                                Text('Check this if you have a car',style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.circular(25)),
                            child: TextButton(
                                onPressed: ()
                                 {
                                   if(formkey.currentState!.validate())
                                     {
                                       cubit.submitPhoneNumber(phoneController.text,);

                                           Navigator.of(context)
                                               .push(MaterialPageRoute(
                                               builder: (context)=> VerificationScreen(name:nameController.text,num:phoneController.text, car: car,))
                                           );

                                       // Navigator.of(context)
                                       //     .push(MaterialPageRoute(
                                       //     builder: (context)=>const VerificationScreen())
                                       // );
                                     }

                                   //Navigator.of(context)
                                //
                                //     .push(MaterialPageRoute(
                                //     builder: (context)=>const VerificationScreen())
                                // );




                                },
                                child: const Text('Get Started',style:  TextStyle(fontSize:25,color: Colors.white),)),
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
         )

    );
  }
}
