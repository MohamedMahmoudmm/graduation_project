import 'dart:async';
import 'dart:collection';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:help_on_route/map/cubit/states.dart';
import 'package:help_on_route/model/requests_model/request_model.dart';
import 'package:help_on_route/model/user_model/user_model.dart';
import 'package:help_on_route/network/local/cache_helper.dart';
import 'package:help_on_route/shared/constant.dart';
import 'package:help_on_route/shared/dio_helper.dart';
import 'package:location/location.dart';


class MapCubit extends Cubit<MapsStates>

{
  MapCubit():super(MapInitialState());
  static MapCubit get(context)=>BlocProvider.of(context);
 // LatLng? currentLatLng;
  Completer<GoogleMapController> controllerM =Completer();
   CameraPosition position1=CameraPosition(target: LatLng(29.311363205186876, 30.847196392714977));
  void myloc()async{
    await Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition();

   position1 = CameraPosition(
      zoom: 17,
      target: LatLng(position.latitude, position.longitude)
  );
    goToMyLocation();
}
  Future<void> goToMyLocation()async
  {
    final GoogleMapController controller=await controllerM.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position1));
  }
  LocationData? currentLocation;

  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
          (location) {
        currentLocation = location;

      },
    );
    GoogleMapController googleMapController = await controllerM.future;
    location.onLocationChanged.listen(
          (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );

      },
    );
  }

  dynamic position;
  LocationPermission? permission;

  var marker=HashSet<Marker>();

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints(UserModel model) async {
    polylineCoordinates = [];
    getLocation();
    GoogleMapController googleMapController = await controllerM.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 13.5,
          target: LatLng(
            position.latitude!,
            position.longitude!,
          ),
        ),
      ),
    );
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBmlAAN57xXHaEV6FNYDty8c6JDl5ecw_k', // Your Google Map Key
      PointLatLng(position.latitude,  position.longitude),
      PointLatLng(model.lat!, model.long!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
            (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      //setState(() {});
    }

    emit(GetRoute());
  }

  Future<void> getLocation()async
  {
    await Geolocator.requestPermission();
     position = await Geolocator.getCurrentPosition();



    print(position.longitude);
    print('5555555'+position.toString());
    print(position.latitude);

  }

   final Polyline line=Polyline(
      polylineId: PolylineId('line1'),
  width: 3,
  points: [
    LatLng(29.30995 ,30.8418 ,),
    LatLng(29.30995 ,30.8300)
  ]);
   final Polygon plg= Polygon(
     polygonId: PolygonId('5'),
     fillColor: Colors.transparent,
     strokeWidth: 5,

     points:
     [
       LatLng(29.30995 ,30.8300),
       LatLng(29.30995 ,30.8418 ,),
       LatLng(29.29995 ,30.8418 ,),
       LatLng(29.29995 ,30.8300)
     ]
   );
  double dis=0.0;
   Future<double> getDistence(UserModel model)async
   {
     getLocation();

     dis=double.parse(( Geolocator.distanceBetween(position.latitude , position.longitude,
         model.lat! ,model.long!)).toStringAsFixed(0));
     print( 'ddd'+dis.toString());
     emit(CalcDistence());
     return dis;

   }

double? dd;
  List<UserModel> allUser = [];
   Future<void> getUsers()async
   {
      await Geolocator.requestPermission();
     dynamic position = await Geolocator.getCurrentPosition();
       FirebaseFirestore.instance
         .collection("users")
          .snapshots()
          .listen((value)
     {
       allUser=[];
       value.docs.forEach((element) {

         double dis=double.parse(( Geolocator.distanceBetween(position.latitude , position.longitude,
             element.data()['lat'] ,element.data()['long'])).toStringAsFixed(0));
         print(element.data()['uId']);
         print('dis:$dis');
       if(dis<1000 && element.data()['car']==true && uId != element.data()['uId']) {
         if(allUser.isNotEmpty)
         {
           double dis2=double.parse(( Geolocator.distanceBetween(position.latitude , position.longitude,
               allUser[0].lat! ,allUser[0].long!)).toStringAsFixed(0));

           if(dis <= dis2)
             {
               allUser.insert(0,UserModel.fromJson(element.data()));
             }
           else
           {
             allUser.add(UserModel.fromJson(element.data()));
           }
         }
         else
           {
             allUser.add(UserModel.fromJson(element.data()));
           }

          //allUser.insert(0, UserModel.fromJson(element.data()));
          print('done');
        }
      });
       if(allUser.isNotEmpty){
        dd = double.parse((Geolocator.distanceBetween(position.latitude,
                position.longitude, allUser[0].lat!, allUser[0].long!))
            .toStringAsFixed(0));
      }
      print('fffffff  :${allUser.length}');
       print("geeeeeeeeet");
       //update();
       addMarker();

       emit(GetAllUserLocationSuccess());

     });
   }

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  void followUsers()
   {
  //
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uId)
  //       .collection('chats')
  //       .doc(receiverId)
  //       .collection('messages')
  //       .orderBy('dateTime')
  //       .snapshots()
  //       .listen((event) {
  //     messages = [];
  //     event.docs.forEach((element) {
  //       messages.add(ChatoMessageModel.fromJson(element.data()));
  //     });
  //
  //     getLastMessage(receiverId: receiverId);
  //     //print('222');
  //     //lastMessages=messages[messages.length-1].text;
  //     //print(lastMessages[]);
  //     emit(ChatoGetMessageSuccessState());
  //   });
  }
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/Pin_source.png")
        .then(
          (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/Pin_destination.png")
        .then(
          (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/Badge.png")
        .then(
          (icon) {
        currentLocationIcon = icon;
      },
    );
  }
  //var nn;
  //double? dd;
  // Future<void> update()async
  // {
  //   await getLocation();
  //   allUser.forEach((element) {
  //
  //     var dd=(Geolocator.distanceBetween(position.latitude , position.longitude,
  //         element.lat! ,element.long!)).toStringAsFixed(0);
  //     UserModel model=UserModel(
  //       name:element.name,
  //       phone:element.phone,
  //       uId:element.uId,
  //       long:element.long,
  //       lat: element.lat,
  //       dis: dd,
  //     );
  //      FirebaseFirestore
  //         .instance
  //         .collection("users")
  //         .doc(element.uId).update(model.toMap()).then((value) {
  //
  //       print(model.uId);
  //       emit(UpdateAllUserDisSuccess());
  //
  //     }).catchError((onError)
  //     {
  //       print('22222'+onError.toString());
  //     });
  //   });
  // }
  void addMarker()async
  {
    //getUsers();
    print('adddddd');
    marker.clear();

    allUser.forEach((element)
    {
      //dd=getDistence(element) as double?;
     // if(getDistence(model)<dd)

      print('111555555'+element.uId!);
      marker.add(Marker(

        markerId: MarkerId(element.phone!),
        position: LatLng(element.lat! ,element.long!),

        infoWindow: InfoWindow(
          title: element.uId,
          onTap: ()
          {
            getDistence(element);
            getPolyPoints(element);
            //print(element["id"]);
          },
        ),
        //icon: BitmapDescriptor.
      ));
    });
    print('88888888888');
    print(marker.length);


    emit(AddMarkerState());

  }
  void request()async{
   UserModel pModel;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId).get().then((value)async
    {
      pModel=UserModel.fromJson(value.data()!);

      double dis=double.parse(( Geolocator.distanceBetween(pModel.lat! , pModel.long!,
          allUser[0].lat! ,allUser[0].long!)).toStringAsFixed(0));
      print('dis= $dis');
      RequestModel model=RequestModel(
        accept: false,
        distance: dis,
        patientData:pModel ,
        helperData: allUser[0],
      );
       FirebaseFirestore.instance
          .collection('requests')
          .add(model.toMap()).then((value) {
            CacheHelper.saveData(key: 'myRequest', value: value.id);
            print('done');

             Api().sendFcm(value.id, '$dis', allUser[0].deviceId!);
            print('ffff');
            emit(SendRequest());
          }).catchError((error){
            print('ddddddddd'+error.toString());
       });



    } ).catchError((error){
      print(error.toString());
    });

  }
  String text='the patient is here ';
  bool visiable=false;
  void acceptReq(var myReq)
  {
    if(myReq !=''){
      FirebaseFirestore.instance
          .collection('requests')
          .doc(myReq)
          .snapshots()
          .listen((event) {
        if (event.data()!['accept']) {

            text =
            'there is a helper accept your request\n he is coming to you';
            visiable = true;
         emit(AcceptReq());
        }
        else
        {
          visiable = false;
        }
      });
    }
  }
  double? hoLat;
  double? hoLong;
  Future<void> goToHospital(double lat ,double long)async
  {

    try {
      final response = await Dio().get('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$long&radius=2000&type=hospital&key=AIzaSyCgws2nMUNNny_p0wUgAH2u9q2bcdScon8');
      if (response.statusCode == 200) {
        var hosLoc=response.data['results'][0]['geometry']['location'];
        hoLat=hosLoc['lat'];
        hoLong=hosLoc['lng'];

      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: ${e.toString()}');
    }
  }
  void refresh()
  {

      emit(Refresh());

  }
}

  // {
  //   DioHelper.postData(url: 'https://fcm.googleapis.com/fcm/send',
  //
  //       data: {
  //         "to": "dv27AU1mTpGk3hG_B7Lc9k:APA91bGKB-UDTy4EH8HyXiix185p_Wuk-0_ObZ0tECiYQu-fHBF9rGTPq2yn3ml0y3PP9vSwyRu17Lp0rsTi7kF_Tb0pLhsFTqVBy3ATQIEVT3591GBlurgNrSxt5EFf_DUsvuXoiMJL",
  //         "notification": {
  //           "body": "Firebase Cloud Message Body",
  //           "title": "Firebase Cloud Message Title",
  //           "subtitle": "Firebase Cloud Message Subtitle"
  //         }
  //   }).then((value)
  //   {
  //     print('rrrr');
  //   }).catchError((error){
  //     print('44444:$error');
  //   });
  //
  //
  // }

  // void getlo()async
  // {
  //   permission = await Geolocator.requestPermission();
  //   await Geolocator.getCurrentPosition().then((currLocation){
  //
  //       currentLatLng = new LatLng(currLocation.latitude, currLocation.longitude);
  //
  //   });
  //
  //   emit(AddLocationState());
  //