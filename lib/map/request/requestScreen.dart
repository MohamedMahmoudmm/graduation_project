// import 'dart:async';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:help_on_route/main.dart';
// import 'package:help_on_route/map/cubit/cubit.dart';
// import 'package:help_on_route/map/cubit/states.dart';
// import 'package:help_on_route/model/requests_model/request_model.dart';
// import 'package:help_on_route/model/user_model/user_model.dart';
// import 'package:help_on_route/network/local/cache_helper.dart';
// import 'package:help_on_route/shared/constant.dart';
// import 'package:location/location.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
// import 'package:url_launcher/url_launcher.dart';
//
//
//
// class RequestScreen extends StatefulWidget {
//   const RequestScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RequestScreen> createState() => _RequestScreenState();
// }
//
// class _RequestScreenState extends State<RequestScreen> with WidgetsBindingObserver {
//  bool visible=false;
//  String text='the patient is here ';
//  String buttonText='Send Request ';
//  String ttText='the patient is here ';
//  bool accept=false;
//  var myReqUId;
//  String? number;
//   @override
//
//   initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//      //myReqUId=CacheHelper.getData(key: 'myRequest');
//     print('000000000000000000000000000000000000000000');
//     accept=true;
//      FirebaseFirestore.instance.collection('requests').doc(requestData).get().then((request) {
//        {
//          RequestModel reqModel =RequestModel(
//
//              distance: request.data()!['distance'],
//              patientData: UserModel.fromJson(request.data()!['patientData']),
//              helperData: UserModel.fromJson(request.data()!['helperData']),
//              accept: true, helpers: []);
//          number=UserModel.fromJson(request.data()!['patientData']).phone;
//          FirebaseFirestore.instance.collection('requests').doc(requestData).update(reqModel.toMap());
//          if(request.data()!['distance']<10)
//          {
//            visible=true;
//            setState(() {});
//          }
//          var value=UserModel.fromJson(request.data()!['patientData']);
//          getPolyPoints(value);
//          // }).catchError((error){print('1111111111'+error.toString());});
//          print('ppppppppp1: ${polylineCoordinates.length}');
//        }
//      });
//     // .then((value) {
//     //print(value.data()!['uId']);
//
//
//
//
//     //getCurrentLocation();
//
//     //final text = TextPreferences.getText();
//     //controller = TextEditingController(text: text);
//   }
//   List<LatLng> polylineCoordinates = [];
//   Completer<GoogleMapController> controllerM =Completer();
//   Future<void> getPolyPoints(UserModel model) async {
//     print('from routeeeeee');
//     print(model.long);
//     print(model.lat);
//     polylineCoordinates = [];
//     Location location = Location();
//     var myLoc=await location.getLocation();
//     print('bbb');
//     // GoogleMapController googleMapController = await controllerM.future;
//     // print('bbb');
//     // googleMapController.animateCamera(
//     //   CameraUpdate.newCameraPosition(
//     //     CameraPosition(
//     //       zoom: 13.5,
//     //       target: LatLng(
//     //         myLoc.latitude!,
//     //         myLoc.longitude!,
//     //       ),
//     //     ),
//     //   ),
//     // );
//     print('bbbbbbbbbbbb');
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyBmlAAN57xXHaEV6FNYDty8c6JDl5ecw_k', // Your Google Map Key
//       PointLatLng(myLoc.latitude!,  myLoc.longitude!),
//       PointLatLng(model.lat!, model.long!),
//     );
//     print('ddddddd');
//     if (result.points.isNotEmpty) {
//       print('................');
//       result.points.forEach(
//             (PointLatLng point) => polylineCoordinates.add(
//           LatLng(point.latitude, point.longitude),
//         ),
//       );
//       setState(() {});
//     }
//     print('pppppppp2: ${polylineCoordinates.length}');
//
//
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//
//     if (state == AppLifecycleState.inactive ||
//         state == AppLifecycleState.detached ||
//         state == AppLifecycleState.paused) {
//       //getCurrentLocation();
//       // Location location = Location();
//       //
//       // location.onLocationChanged.listen(
//       //       (newLoc) {
//       //         print('**********');
//       //     UserModel model=UserModel(name: 'mohamedddd',
//       //         lat: newLoc.latitude,
//       //         long: newLoc.longitude,
//       //         phone: '0122222222',
//       //         uId: '7oMw5DfyJFT6LKzAHpG88iUWetU2');
//       //      FirebaseFirestore.instance.collection('users').doc('7oMw5DfyJFT6LKzAHpG88iUWetU2')
//       //          .update(model.toMap())
//       //          .then((value)
//       //      {
//       //        print('changeeeeeeeee');
//       //      })
//       //          .catchError((error){
//       //            print('nooooooooooooot');
//       //      });
//       //
//       //   },
//       // );
//       // print('ggg');
//       return;
//     }
//
//     final isBackground = state == AppLifecycleState.paused;
//
//     if (isBackground) {
//       //getCurrentLocation();
//       //TextPreferences.setText(controller.text);
//       print('hiiiiii');
//     }
//
//     /* if (isBackground) {
//       // service.stop();
//     } else {
//       // service.start();
//     }*/
//   }
//   final Completer<GoogleMapController> _controller = Completer();
//   LocationData? currentLocation;
//   void getCurrentLocation() async {
//     Location location = Location();
//
//     location.onLocationChanged.listen(
//           (newLoc) {
//         print('555555444');
//
//         FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
//           UserModel model=UserModel(name: value.data()!['name'],
//               car: value.data()!['car'],
//               lat: newLoc.latitude,
//               long: newLoc.longitude,
//               phone: value.data()!['phone'],
//               uId: uId, deviceId: value.data()!['deviceId']);
//           if(!value.data()!['car'] )
//             {
//               print('1111');
//               return;
//             }
//           FirebaseFirestore.instance.collection('users').doc(uId)
//               .update(model.toMap())
//               .then((value)
//           {
//             print('change: '+uId!);
//           })
//               .catchError((error){
//             print('noot');
//           });
//           setState((){});
//         },
//         );
//         });
//
//   }
//
//
//   FloatingSearchBarController barController=FloatingSearchBarController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (BuildContext context)=>MapCubit(),//..myloc(),//..getUsers(),
//       child: BlocConsumer<MapCubit,MapsStates>(
//         listener: (context,state){},
//         builder: (context,state)
//         {
//           var cubit=MapCubit.get(context);
//           return SafeArea(
//             child: Scaffold(
//               // appBar: AppBar(
//               //   actions: [
//               //     IconButton(onPressed: (){
//               //       goToMyLocation();
//               //     }, icon:Icon(Icons.location_on) )
//               //   ],
//               // ),
//                 body: Stack(
//                   fit: StackFit.expand,
//                   children: [
//
//                     GoogleMap(
//
//                       initialCameraPosition: cubit.position1,
//                       mapType: MapType.normal,
//                       compassEnabled: false,
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: false,
//                       onTap: (location)
//                       {
//                         print(location.longitude);
//                         print(location.latitude);
//                       },
//
//
//                       onMapCreated: (GoogleMapController controller)
//                       {
//                        // print('polypoint : ${polylineCoordinates.length}');
//                        // cubit.acceptReq(CacheHelper.getData(key: 'myRequest'));
//                         // Marker(
//                         //   position: LatLng(29.308508645596635, 30.845269560813904),
//                         //     markerId: MarkerId('1')
//                         // );
//                         //cubit.getUsers();
//                         //cubit.addMarker();
//
//                         cubit.controllerM.complete(controller);
//
//                       },
//                       markers: cubit.marker,
//                   polylines: {
//                     Polyline(
//                       polylineId: const PolylineId("route"),
//                       points: polylineCoordinates,
//                       color: const Color(0xFF7B61FF),
//                       width: 6,
//                     ),
//                   },
//
//                     ),
//                     Visibility(
//                       visible: cubit.visiable,
//                       child: Align(
//                         alignment: Alignment.topCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 15),
//                           child: Container(
//
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(15)
//
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(cubit.text,style: TextStyle(fontSize: 18,color: Colors.black),),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 60,
//                       right: 10,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0,),
//                         child: Container(
//                           height: 60,
//                           width:120,
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(12)
//                           ),
//
//                           child: TextButton(
//                             onPressed: (){
//                               CacheHelper.saveData(key: 'myRequest', value: '');
//
//                               setState(()
//                               {
//                                 myReqUId=CacheHelper.getData(key: 'myRequest');
//                               });
//
//                             },
//                             child: Text('tab to end request',
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20
//                               ),),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // FloatingSearchBar(
//                     //   controller: barController,
//                     //   elevation: 5,
//                     //   hintStyle: TextStyle(
//                     //     fontSize: 17,
//                     //   ),
//                     //   queryStyle: TextStyle(
//                     //     fontSize: 17,
//                     //   ),
//                     //   hint: 'Search here',
//                     //   border: BorderSide(
//                     //       style: BorderStyle.none
//                     //   ),
//                     //   height: 50,
//                     //   onQueryChanged: (query)
//                     //   {
//                     //
//                     //   },
//                     //   builder: (BuildContext context, Animation<double> transition)
//                     //   {
//                     //     return ClipRRect(
//                     //       borderRadius: BorderRadius.circular(8),
//                     //       child: Material(
//                     //         color: Colors.white,
//                     //         elevation: 4.0,
//                     //         child: Column(
//                     //             mainAxisSize: MainAxisSize.min,
//                     //             children:[
//                     //               Container(height: 100, color: Colors.indigo)
//                     //               //   Colors.accents.map((color) {
//                     //               //   return Container(height: 5, color: color);
//                     //               // }).toList(),
//                     //             ]
//                     //         ),
//                     //       ),
//                     //     );
//                     //   },
//                     //
//                     // ),
//                     Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(bottom: 10.0),
//                         child: Container(
//                           height: 150,
//                           width:double.infinity,
//                           color: Colors.white,
//                           child:Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                 children: [
//                                   // Text(cubit.allUser.isNotEmpty?'The nearest Helper is ${cubit.dd}m away':'there is no helper near you',
//                                   //   style: TextStyle(
//                                   //       color: Colors.black,
//                                   //       fontSize: 22
//                                   //   ),),
//
//                                   Container(
//                                     height: 60,
//                                     //width:double.infinity,
//                                     decoration: BoxDecoration(
//                                         color: Colors.black,
//                                       borderRadius: BorderRadius.circular(12)
//                                     ),
//
//                                     child: TextButton(
//                                       onPressed: (){
//
//                                             //launch("tel://$number");
//
//                                         },
//                                       child: Text('Go to Hospital',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20
//                                         ),),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 60,
//                                     //width:double.infinity,
//                                     decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         borderRadius: BorderRadius.circular(12)
//                                     ),
//
//                                     child: TextButton(
//                                       onPressed: (){
//                                         //launch("tel://$number");
//
//                                       },
//                                       child: Text('tab to call him',
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 20
//                                         ),),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
