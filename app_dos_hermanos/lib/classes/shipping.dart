import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ShippingStatus{newShipping, completedShipping, inTravelShipping, downloadedShipping, unknownStatus, deletedShipping}

class Shipping {
  String truckPatent, chasisPatent, driverName;
  ShippingStatus shippingState;
  String? remiterTara, remiterFullWeight, reciverTara, reciverFullWeight;
  DateTime? remiterTaraTime, remiterFullWeightTime, reciverTaraTime, reciverFullWeightTime;
  String? remiterTaraUser, remiterFullWeightUser, reciverTaraUser, reciverFullWeightUser;
  String? remiterLocation, reciverLocation;
  String? riceType, id, crop, departure, humidity;

  Shipping({
    required this.driverName,
    required this.shippingState,
    required this.truckPatent,
    required this.chasisPatent,
    this.remiterTara, this.remiterFullWeight, this.reciverTara, this.reciverFullWeight, 
    this.remiterTaraTime, this.remiterFullWeightTime, this.reciverTaraTime, this.reciverFullWeightTime, 
    this.remiterTaraUser, this.remiterFullWeightUser, this.reciverTaraUser, this.reciverFullWeightUser, 
    this.remiterLocation, this.reciverLocation, 
    this.riceType, this.id, this.crop, this.departure, this.humidity
  });

  static Shipping fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Shipping(
      shippingState: statusFromString(data['shippingState']),
      truckPatent: data['truckPatent'],
      driverName: data['driverName'],
      chasisPatent: data['chasisPatent'],
      remiterFullWeight: data['remiterFullWeight'],
      remiterFullWeightTime: DateTime.tryParse(data['remiterFullWeightTime']),
      remiterFullWeightUser: data['remiterFullWeightUser'],
      remiterLocation: data['remiterLocation'],
      remiterTara: data['remiterTara'],
      remiterTaraTime: DateTime.tryParse(data['remiterTaraTime']),
      remiterTaraUser: data['remiterTaraUser'],
      reciverFullWeight: data['reciverFullWeight'],
      reciverFullWeightTime: DateTime.tryParse(data['reciverFullWeightTime']),
      reciverFullWeightUser: data['reciverFullWeightUser'],
      reciverLocation: data['reciverLocation'],
      reciverTara: data['reciverTara'],
      reciverTaraTime: DateTime.tryParse(data['reciverTaraTime']),
      reciverTaraUser: data['reciverTaraUser'],
      riceType: data['riceType'],
      id: data['id'],
      crop: data['crop'],
      departure: data['departure'],
      humidity: data['humidity']
    );
  }

  String get getStatus {
    switch (shippingState){
      case ShippingStatus.newShipping:
        return 'newShipping';
      case ShippingStatus.completedShipping:
        return 'completedShipping';
      case ShippingStatus.inTravelShipping:
        return 'inTravelShipping';
      case ShippingStatus.downloadedShipping:
        return 'downloadedShipping';
      case ShippingStatus.unknownStatus:
        return 'unknownStatus';
      case ShippingStatus.deletedShipping:
        return 'deletedShipping';
    }
  }

  Icon get statusIcon {
    switch (shippingState){
      case ShippingStatus.newShipping:
        return Icon(Icons.fiber_new_outlined,color: Colors.amber,);
      case ShippingStatus.completedShipping:
        return Icon(Icons.done, color: Colors.green,);
      case ShippingStatus.inTravelShipping:
        return Icon(Icons.send, color: Colors.blueGrey,);
      case ShippingStatus.downloadedShipping:
        return Icon(Icons.call_received, color: Colors.blue);
      case ShippingStatus.unknownStatus:
        return Icon(Icons.new_releases_outlined, color: Colors.red,);
      case ShippingStatus.deletedShipping:
        return Icon(Icons.not_interested_sharp, color: Colors.redAccent);
      default: 
        return Icon(Icons.new_releases_outlined, color: Colors.red);
    }
  }

  void nextStatus (){
    switch (shippingState){
      case ShippingStatus.newShipping:
        shippingState = ShippingStatus.inTravelShipping;
      break;
      case ShippingStatus.inTravelShipping:
        shippingState = ShippingStatus.downloadedShipping;
      break;
      case ShippingStatus.downloadedShipping:
        shippingState = ShippingStatus.completedShipping;
      break;
      case ShippingStatus.completedShipping:
        shippingState = ShippingStatus.completedShipping;
      break;
      case ShippingStatus.unknownStatus:
        shippingState = ShippingStatus.unknownStatus;
      break;
      case ShippingStatus.deletedShipping:
        shippingState = ShippingStatus.deletedShipping;
      break;
    }
  }
}

ShippingStatus statusFromString(String string){
  switch (string){
    case 'newShipping':
      return ShippingStatus.newShipping;
    case 'completedShipping':
      return ShippingStatus.completedShipping;
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