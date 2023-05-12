
import '../user_model/user_model.dart';

class RequestModel
{

  double? distance;
   UserModel? patientData;
   UserModel? helperData;
    bool accept=false;

   RequestModel(
      {
        required this.distance,
         required this.patientData,
        required this.helperData,
        required this.accept

      }
      );

  RequestModel.fromJson(Map< String,dynamic> json)
  {
    distance = json['distance'];
    accept = json['accept'];
    patientData = UserModel.fromJson(json['patientData']);
    helperData = UserModel.fromJson(json['helperData']);
  }
  Map<String,dynamic> toMap() {
    return
      {

        'distance': distance,
        'accept': accept,
        'patientData':patientData!.toMap(),
        'helperData':helperData!.toMap(),

      };
  }

}


