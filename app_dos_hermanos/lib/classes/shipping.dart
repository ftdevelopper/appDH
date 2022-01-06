import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ShippingStatus{newShipping, completedShipping, inTravelShipping, downloadedShipping, unknownStatus, deletedShipping}

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
      case ShippingStatus.completedShipping:
        return 'completedShipping';
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