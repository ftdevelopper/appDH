import 'package:cloud_firestore/cloud_firestore.dart';

enum ShippingStatus{newShipping, loadingShipping, inTravelShipping, downloadedShipping, unknownStatus, deletedShipping}

class Shipping {
  String patent;
  ShippingStatus shippingState;
  String? remiterTara, remiterFullWeight, reciverTara, reciverFullWeight;
  String? remiterTaraTime, remiterFullWeightTime, reciverTaraTime, reciverFullWeightTime;
  String? remiterTaraUser, remiterFullWeightUser, reciverTaraUser, reciverFullWeightUser;
  String? remiterLocation, reciverLocation;
  String? riceType;

  Shipping({
    required this.shippingState,
    required this.patent,
    this.remiterTara, this.remiterFullWeight, this.reciverTara, this.reciverFullWeight, 
    this.remiterTaraTime, this.remiterFullWeightTime, this.reciverTaraTime, this.reciverFullWeightTime, 
    this.remiterTaraUser, this.remiterFullWeightUser, this.reciverTaraUser, this.reciverFullWeightUser, 
    this.remiterLocation, this.reciverLocation, 
    this.riceType
  });

  static Shipping fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Shipping(
      shippingState: statusFromString(data['shippingState']),
      patent: data['patent'],
      remiterFullWeight: data['remiterFullWeight'],
      remiterFullWeightTime: data['remiterFullWeightTime'],
      remiterFullWeightUser: data['remiterFullWeightUser'],
      remiterLocation: data['remiterLocation'],
      remiterTara: data['remiterTara'],
      remiterTaraTime: data['remiterTaraTime'],
      remiterTaraUser: data['remiterTaraUser'],
      reciverFullWeight: data['reciverFullWeight'],
      reciverFullWeightTime: data['reciverFullWeight'],
      reciverFullWeightUser: data['reciverFullWeightUser'],
      reciverLocation: data['reciverLocation'],
      reciverTara: data['reciverTara'],
      reciverTaraTime: data['reciverTaraTime'],
      reciverTaraUser: data['reciverTaraUser'],
      riceType: data['riceType']
    );
  }

  String getStatus (ShippingStatus status){
    switch (status){
      case ShippingStatus.newShipping:
        return 'newShipping';
      case ShippingStatus.loadingShipping:
        return 'loadingShipping';
      case ShippingStatus.inTravelShipping:
        return 'inTravelShipping';
      case ShippingStatus.downloadedShipping:
        return 'sownloadedShipping';
      case ShippingStatus.unknownStatus:
        return 'unknownStatus';
      case ShippingStatus.deletedShipping:
        return 'deletedShipping';
    }
  }
}

ShippingStatus statusFromString(String string){
    switch (string){
      case 'newShipping':
        return ShippingStatus.newShipping;
      case 'loadingShipping':
        return ShippingStatus.loadingShipping;
      case 'inTravelShipping':
        return ShippingStatus.inTravelShipping;
      case 'downloadedShipping':
        return ShippingStatus.downloadedShipping;
      case 'unknownStatus':
        return ShippingStatus.unknownStatus;
      case 'deletedShiping': 
        return ShippingStatus.unknownStatus;
      default:
        return ShippingStatus.unknownStatus;
    }
  }