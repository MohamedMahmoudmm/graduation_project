import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_on_route/main.dart';
import 'package:help_on_route/map/cubit/cubit.dart';
import 'package:help_on_route/map/cubit/states.dart';
import 'package:help_on_route/map/request/requestScreen.dart';
import 'package:help_on_route/model/requests_model/request_model.dart';
import 'package:help_on_route/model/user_model/user_model.dart';
import 'package:help_on_route/network/local/cache_helper.dart';
import 'package:help_on_route/notification.dart';
import 'package:help_on_route/shared/constant.dart';
import 'package:help_on_route/shared/dio_helper.dart';
import 'package:location/location.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:url_launcher/url_launcher.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
 bool visible=false;
 String text='the patient is here ';
 String buttonText='Send Request ';
 //String ttText='the patient is here ';
 String hotime='0 mins';
 double hodis=0.0;
 bool accept=false;
 var myReqUId;
 var myHelp;
 String? number;
  @override

  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //Api().sendFcm('Helper', 'helper accept your request', 'e2352mXPReenwBJ01LvP8R:APA91bGEwaFnlsMDM4IdoWhtbgHoCZi3HqnHlgSl4CiDeHcZlWAb4_OM40VDqEeHE-0jofel7bxEpvomntWIZUCUWmh8rAgQG7ecYTYCNIBhaSyoIs16o7GPqDTvgmUgYnwOB5uc9oed');
     myReqUId=CacheHelper.getData(key: 'myRequest');
    requestData=CacheHelper.getData(key: 'myHelp');
    if(requestData !='')
      {
        acceptR();
      }



    AwesomeNotifications().actionStream.listen((event)async {
      print('ffffffffff :  ${event.buttonKeyPressed}');
      //print(event.)

      // Timer(const Duration(seconds: 10), () {
      //   AwesomeNotifications().dismiss(event.id!);
      // });



      if (event.buttonKeyPressed == 'yes')
      {
        print('000000000000000000000000000000000000000000');
        accept=true;

        acceptReq();
      }

    });
    //getCurrentLocation();

    //final text = TextPreferences.getText();
    //controller = TextEditingController(text: text);
  }
  List<LatLng> polylineCoordinates = [];
 List<LatLng> polylineCoordinatesToHos = [];
  Completer<GoogleMapController> controllerM =Completer();
  void acceptR()async
  {

    var request= await FirebaseFirestore.instance.collection('requests').doc(requestData).get();
    number=UserModel.fromJson(request.data()!['patientData']).phone;

    print('11111'+request.data()!['helpers'][0]['phone']);
    accept=true;
    if(request.data()!['distance']<10)
    {
      visible=true;
      setState(() {});
    }
    var value=UserModel.fromJson(request.data()!['patientData']);

    await getPolyPoints(value.lat!,value.long!);
    // }).catchError((error){print('1111111111'+error.toString());});
    print('ppppppppp1: ${polylineCoordinates.length}');
  }
  void acceptReq()async
  {
    /*
     {
    var request= await FirebaseFirestore.instance.collection('requests').doc(requestData).get();
    number=UserModel.fromJson(request.data()!['patientData']).phone;

     if(request.data()!['distance']<10)
    {
      visible=true;
      setState(() {});
    }
    var value=UserModel.fromJson(request.data()!['patientData']);
    Api().sendFcm('Helper', 'helper accept your request', value.deviceId!);

    await getPolyPoints(value.lat!,value.long!);
    // }).catchError((error){print('1111111111'+error.toString());});
    print('ppppppppp1: ${polylineCoordinates.length}');
  }*/
    var request= await FirebaseFirestore.instance.collection('requests').doc(requestData).get();
    var helper= await FirebaseFirestore.instance.collection('users').doc(uId).get();

    List<dynamic> list=request.data()!['helpers'];
    //print(helper.data()!);
    list.add(
      UserModel(name: helper.data()!['name'],
          deviceId: helper.data()!['deviceId'],
          car: helper.data()!['car'],
          lat: helper.data()!['lat'],
          long: helper.data()!['long'],
          phone: helper.data()!['phone'],
          uId: helper.data()!['uId']).toMap()
    );
    print('listtttttt'+list.toString());
    if(!request.data()!['accept'])
      {
        CacheHelper.saveData(key: 'myHelp', value: requestData);
        FirebaseFirestore.instance.collection('requests')
            .doc(requestData).update(
            {
              'accept':true,
              'helpers':list
            });
        number=UserModel.fromJson(request.data()!['patientData']).phone;
        accept=true;
        if(request.data()!['distance']<20)
        {
          visible=true;
          setState(() {});
        }
        var value=UserModel.fromJson(request.data()!['patientData']);
        Api().sendFcm('Helper', 'helper accept your request', value.deviceId!);

        await getPolyPoints(value.lat!,value.long!);
        // }).catchError((error){print('1111111111'+error.toString());});
        print('ppppppppp1: ${polylineCoordinates.length}');
      }
    else{
      CacheHelper.saveData(key: 'Help', value: requestData);

      FirebaseFirestore.instance.collection('requests')
          .doc(requestData).update(
          {
            'helpers':list
          });
      Notify.instantNotify('there is helper went to help ,Wait till he finish ');
    }


  }
 Future<void> getHosPolyPoints(double lat ,double long) async {
   Dio dio = new Dio();

   print(lat);
   polylineCoordinatesToHos = [];
   Location location = Location();
   var myLoc=await location.getLocation();
   Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${myLoc.latitude},${myLoc.longitude}&destinations=$lat,$long&key=AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8");
   hotime=response.data['rows'][0]['elements'][0]['duration']['text'];
   print(response.data['rows'][0]['elements'][0]['duration']['text']);
   hodis=double.parse((Geolocator.distanceBetween(myLoc.latitude!,
       myLoc.longitude!, lat, long))
       .toStringAsFixed(0));
   print('bbb');
   // GoogleMapController googleMapController = await controllerM.future;
   // print('bbb');
   // googleMapController.animateCamera(
   //   CameraUpdate.newCameraPosition(
   //     CameraPosition(
   //       zoom: 13.5,
   //       target: LatLng(
   //         myLoc.latitude!,
   //         myLoc.longitude!,
   //       ),
   //     ),
   //   ),
   // );
   print('bbbbbbbbbbbb');
   PolylinePoints polylinePoints = PolylinePoints();
   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
     'AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8', // Your Google Map Key
     PointLatLng(myLoc.latitude!,  myLoc.longitude!),
     PointLatLng(lat, long),
   );
   print('ddddddd');
   if (result.points.isNotEmpty) {
     print('................');
     result.points.forEach(
           (PointLatLng point) => polylineCoordinatesToHos.add(
         LatLng(point.latitude, point.longitude),
       ),
     );
     setState(() {});
   }
   print('pppppppp2: ${polylineCoordinatesToHos.length}');


 }

 Future<void> getPolyPoints(double lat ,double long) async {
    print('from routeeeeee');
    Dio dio = new Dio();

    print(long);
    print(lat);
    polylineCoordinates = [];
    Location location = Location();
    var myLoc=await location.getLocation();
    Response response=await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${myLoc.latitude},${myLoc.longitude}&destinations=$lat,$long&key=AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8");
    hotime=response.data['rows'][0]['elements'][0]['duration']['text'];
    hodis=double.parse((Geolocator.distanceBetween(myLoc.latitude!,
        myLoc.longitude!, lat, long))
        .toStringAsFixed(0));
    print(response.data['rows'][0]['elements'][0]['duration']['text']);
    print('bbb');
    // GoogleMapController googleMapController = await controllerM.future;
    // print('bbb');
    // googleMapController.animateCamera(
    //   CameraUpdate.newCameraPosition(
    //     CameraPosition(
    //       zoom: 13.5,
    //       target: LatLng(
    //         myLoc.latitude!,
    //         myLoc.longitude!,
    //       ),
    //     ),
    //   ),
    // );
    print('bbbbbbbbbbbb');
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8', // Your Google Map Key
      PointLatLng(myLoc.latitude!,  myLoc.longitude!),
      PointLatLng(lat, long),
    );
    print('ddddddd');
    if (result.points.isNotEmpty) {
      print('................');
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
    print('pppppppp2: ${polylineCoordinates.length}');


  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      // new request every 3 mins


      var req=CacheHelper.getData(key: 'Help');

      FirebaseFirestore.instance.collection('request').doc(req).get()
      .then((value){

      }).catchError((error){

      });

      Timer(Duration(seconds: 10), () {
        print('2222');
        print("Yeah, this line is printed after 10 seconds");
      });

    }
    //   getCurrentLocation();
    //   Location location = Location();
    //
    //   location.onLocationChanged.listen(
    //         (newLoc) {
    //           print('**********');
    //       // UserModel model=UserModel(name: 'mohamedddd',
    //       //     lat: newLoc.latitude,
    //       //     long: newLoc.longitude,
    //       //     phone: '0122222222',
    //       //     uId: '7oMw5DfyJFT6LKzAHpG88iUWetU2',
    //       //     deviceId: '',
    //       //     car: null);
    //        FirebaseFirestore.instance.collection('users').doc(CacheHelper.getData(key: 'uId'))
    //            .update({
    //          'lat': newLoc.latitude,
    //               'long': newLoc.longitude,
    //        })
    //            .then((value)
    //        {
    //          print('changeeeeeeeee');
    //        })
    //            .catchError((error){
    //              print('nooooooooooooot');
    //        });
    //
    //     },
    //   );
    //   print('ggg');
    //   return;
    // }

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      //getCurrentLocation();
      //TextPreferences.setText(controller.text);
      print('hiiiiii');
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>MapCubit()..myloc(),//..getUsers(),
      child: BlocConsumer<MapCubit,MapsStates>(
        listener: (context,state){},
        builder: (context,state)
        {
          var cubit=MapCubit.get(context);
          return SafeArea(
            child: Scaffold(
              // appBar: AppBar(
              //   actions: [
              //     IconButton(onPressed: (){
              //       goToMyLocation();
              //     }, icon:Icon(Icons.location_on) )
              //   ],
              // ),
                body: Stack(
                  fit: StackFit.expand,
                  children: [

                    GoogleMap(

                      initialCameraPosition: cubit.position1,
                      mapType: MapType.normal,
                      compassEnabled: false,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onTap: (location)
                      {
                        print(location.longitude);
                        print(location.latitude);
                      },


                      onMapCreated: (GoogleMapController controller)
                      {
                        print('polypoint : ${polylineCoordinates.length}');
                        cubit.acceptReq(CacheHelper.getData(key: 'myRequest'));
                        // Marker(
                        //   position: LatLng(29.308508645596635, 30.845269560813904),
                        //     markerId: MarkerId('1')
                        // );
                        cubit.getUsers();
                        cubit.addMarker();

                        cubit.controllerM.complete(controller);

                      },
                      markers: cubit.marker,
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId("route"),
                      points: polylineCoordinates,
                      color: const Color(0xFF7B61FF),
                      width: 6,
                    ),
                    Polyline(
                      polylineId: const PolylineId("hospital"),
                      points: polylineCoordinatesToHos,
                      color: Colors.deepOrangeAccent,
                      width: 6,
                    ),
                  },

                    ),

                    // patient is here text
                    Visibility(
                      visible: visible,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Container(

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(text,style: TextStyle(fontSize: 18,color: Colors.black),),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // clear request data button
                    Positioned(
                      top: 45,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                        child: Container(
                          height: 60,
                          width:120,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12)
                          ),

                          child: TextButton(
                            onPressed: (){
                               CacheHelper.saveData(key: 'myRequest', value: '');
                               CacheHelper.saveData(key: 'myHelp', value: '');
                               polylineCoordinates=[];
                               accept=false;

                               cubit.refresh();
                            },
                            child: Text('tab to end request',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                              ),),
                          ),
                        ),
                      ),
                    ),

                    //hospital route button
                    Positioned(
                      top: 140,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                        child: Container(
                          height: 60,
                          width:120,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12)
                          ),

                          child: TextButton(
                            onPressed: ()async{
                              print('55555555555555555555555555555555555555');
                            print(cubit.position.latitude!);
                               await cubit.goToHospital(cubit.position.latitude!,cubit.position.longitude!);

                             getHosPolyPoints(cubit.hoLat!, cubit.hoLong!);

                            },
                            child: Text('Go to hospital',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20
                              ),),
                          ),
                        ),
                      ),
                    ),

                   // hospital route data and direction
                    Positioned(
                      top: 40,
                      left: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          width: 180,
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('distanition name',style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                    fontSize: 18
                                    ), overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                 // Spacer(),
                                  Icon(Icons.location_on_outlined,color: Colors.white,size: 30,)
                                ],
                              ),
                              SizedBox(height: 8,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('500 M',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  ),
                                  Icon(Icons.directions_rounded,color: Colors.grey,size: 30,)
                                ],
                              ),
                              Divider(
                                height: 20,
                                color: Colors.white,
                                indent: 5,
                                endIndent: 5,
                                thickness: 2,

                              ),
                              Row(

                                children: [
                                  Text('${hodis} M',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  ),
                                  Spacer(),
                                  Text(hotime,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  ),                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          height: 160,
                          width:double.infinity,
                          color: Colors.white,
                          child:Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cubit.allUser.isNotEmpty?'The nearest Helper is ${cubit.nearestHelperDis}m away':'there is no helper near you',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22
                                ),),
                              SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0,),
                                child: Container(
                                  height: 60,
                                  width:double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                    borderRadius: BorderRadius.circular(12)
                                  ),

                                  child: TextButton(
                                    onPressed: (){

                                      if(accept)
                                        {
                                          launch("tel://$number");
                                        }
                                      else if(CacheHelper.getData(key: 'myRequest') == ''){
                                        cubit.request();
                                      }


                                      },
                                    child: Text(accept?'tab to call him':buttonText,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      ),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
          );
        },
      ),
    );
  }
}
