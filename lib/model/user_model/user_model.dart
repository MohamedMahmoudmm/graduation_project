class UserModel
{
  String? name;
  String? deviceId;
  String? phone;
  bool? car;
  String? uId;
  double? lat;
  double? long;

  //LocationModel? location;
   UserModel(
      {
        required this.name,
        required this.deviceId,
        required this.car,
        required this.lat ,
        required this.long ,
        required this.phone,
        required this.uId,

        // required String accountImage,

        // required bool isEmailVerified
      }
      );

  UserModel.fromJson(Map< String,dynamic> json)
  {
    name = json['name'];
    deviceId = json['deviceId'];
    car = json['car'];
    lat=json['lat'];
    long=json['long'];
    //location = LocationModel.fromJson(json['location']);
    phone = json['phone'];
    uId = json['uId'];

  }
  Map<String,dynamic> toMap() {
    return
      {
        'name': name,
        'deviceId': deviceId,
        'car': car,
        'lat': lat,
        'long': long,
        'phone': phone,
        'uId': uId,

      };
  }

}


