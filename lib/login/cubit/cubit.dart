

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help_on_route/constant.dart';
import 'package:help_on_route/login/cubit/states.dart';
import 'package:help_on_route/login/verification_screen.dart';
import 'package:help_on_route/map/mapScreen.dart';
import 'package:help_on_route/model/user_model/user_model.dart';
import 'package:help_on_route/network/local/cache_helper.dart';
import 'package:help_on_route/shared/constant.dart';

class HelperLoginCubit extends Cubit<HelperLoginStates>
{
   HelperLoginCubit():super(HelperLoginInitialState());
   static HelperLoginCubit get(context)=>BlocProvider.of(context);


   void createUser({
   required String name,
   required String phone,
     required String uId,
     required bool car
})async
   
{
  //LocationModel? location;

   //await Geolocator.requestPermission();

        Geolocator.getCurrentPosition().then((currLocation)async{
        print('lat: ${currLocation.latitude}');
        print('long: ${currLocation.longitude}');

       // location!.lat=currLocation.latitude;
        //location.long=currLocation.longitude;
        var device=await FirebaseMessaging.instance.getToken();
        UserModel model=UserModel(
            name:name,
            car: car,
            phone:phone,

            uId:uId,
          long:currLocation.longitude,
          lat: currLocation.latitude,
          deviceId:device ,
        );

        FirebaseFirestore.instance.collection('users').doc(uId).set(
            model.toMap()
        ).then((value) {
          modelUser =model;
          print('userrrrrrrr createeeeeeeee');


          emit(HelperCreateUserSuccessState());
        }).catchError((error)
        {
          print('error11: '+error.toString());
          emit(HelperCreateUserErrorState());

        });
      }).catchError((error){
        print('location error: '+error.toString());
      });



    }

    Future<void > submitPhoneNumber(String phoneNumber,)async
    {
      await FirebaseAuth.instance.verifyPhoneNumber(

          phoneNumber: '+2$phoneNumber',
          verificationCompleted: (PhoneAuthCredential credential) async
          {
            print('verificationComplete444444444444444444444444444');
            //await signIn(credential,name);
          },
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: Duration(seconds: 60),
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }


  // void verificationCompleted(PhoneAuthCredential credential)async
  // {
  //   print('verificationComplete');
  //   await signIn(credential);
  // }

  void verificationFailed(FirebaseAuthException exception) //error
  {
    print('verificationFailed');
    print(exception.toString());
    emit(VerificationNumberFailed());
  }
BuildContext? context;
  void codeSent(String verificationId ,int? resendToken)
  {
    print('codeSent');
    myVerificationId=verificationId;
    print('idddddddddd'+verificationId);
   // Navigator.push(context!, MaterialPageRoute(builder: (context)=>VerificationScreen()));
    emit(VerificationCodeSendSuccess());
  }

  void codeAutoRetrievalTimeout(String verificationId)
  {
    print('codeAutoRetrievalTimeout');
  }

  Future<void> submitOTP(String otpCode,String name,bool car,BuildContext context)async
  {
    print('submitcodddd');
    PhoneAuthCredential credential=PhoneAuthProvider.credential(
        verificationId: myVerificationId!,
        smsCode: otpCode);
    print('after submitcodeee');
    signIn(credential, name,car,context);
  }

  Future<void> signIn(PhoneAuthCredential credential,String name,bool car,BuildContext context)async
  {
    FirebaseAuth.instance.signInWithCredential(credential).then((value)
    {

      createUser(
        uId: value.user!.uid,
          car: car,
          name: name,
          phone: value.user!.phoneNumber!);
      print('sign in seccussflly ${value.user!.phoneNumber}');
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MapScreen()));
      uId=value.user!.uid;
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);

      emit(PhoneVerifiedSuccess());
    }).catchError((error){
      print(error.toString());
      emit(PhoneVerifiedError());
    });
  }


}