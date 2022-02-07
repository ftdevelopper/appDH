import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ShippingStatus{newShipping, completedShipping, inTravelShipping, downloadedShipping, unknownStatus, deletedShipping}

class Shipping extends Equatable{
  String truckPatent, chasisPatent, driverName;
  ShippingStatus shippingState;
  String? remiterTara, remiterFullWeight, reciverTara, reciverFullWeight;
  DateTime? remiterTaraTime, remiterFullWeightTime, reciverTaraTime, reciverFullWeightTime;
  String? remiterTaraUser, remiterFullWeightUser, reciverTaraUser, reciverFullWeightUser;
  String? remiterLocation, reciverLocation;
  String? riceType, id, crop, departure, humidity;

  List<dynamic>? actions;
  List<dynamic>? userActions;
  List<dynamic>? dateActions;
  String? remiterWetWeight, remiterDryWeight;
  String? reciverWetWeight, reciverDryWeight;
  String? lote;

  bool isOnLine;

  Shipping({
    required this.driverName,
    required this.shippingState,
    required this.truckPatent,
    required this.chasisPatent,
    this.remiterTara, this.remiterFullWeight, this.reciverTara, this.reciverFullWeight, 
    this.remiterTaraTime, this.remiterFullWeightTime, this.reciverTaraTime, this.reciverFullWeightTime, 
    this.remiterTaraUser, this.remiterFullWeightUser, this.reciverTaraUser, this.reciverFullWeightUser, 
    this.remiterLocation, this.reciverLocation, 
    this.riceType, this.id, this.crop, this.departure, this.humidity,
    this. actions, this.userActions, this.dateActions,
    this.remiterWetWeight, this.remiterDryWeight,
    this.reciverWetWeight, this.reciverDryWeight,
    required this.isOnLine,
    this.lote,
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
      humidity: data['humidity'],
      actions: json.decode(data['actions'] ?? '[]'),
      userActions: json.decode(data['userActions'] ?? '[]'),
      dateActions: json.decode(data['dateActions'] ?? '[]'),
      reciverDryWeight: data['reciverDryWeight'],
      reciverWetWeight: data['reciverWetWeight'],
      remiterDryWeight: data['remiterDryWeight'],
      remiterWetWeight: data['remiterWetWeight'],
      isOnLine: json.decode(data['isOnLine'] ?? 'true'),
      lote: data['lote'],
    );
  }

  void addAction ({required String action, required String user, required String date}){
    actions == null ? actions = [action] : actions!.add(action);
    userActions == null ? userActions = [user] : userActions!.add(user);
    dateActions == null ? dateActions = [date] : dateActions!.add(date);
  }

  double getDryWeight({required double humidity, required double weight}){
    double dryWeight = 0;
    if (humidity <= 13){
      dryWeight = weight;
    } else if (13 < humidity && humidity < 32.0){
      //TODO: CHEQUEAR FORMULA
      dryWeight = weight * (((humidity / 100) * 0.12 + 0.845));
    }
    return dryWeight;
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

  static Shipping fromJson(Map<String, dynamic> jsonShipping){
    return Shipping(
      shippingState: statusFromString(jsonShipping['shippingState']),
      truckPatent: jsonShipping['truckPatent'],
      driverName: jsonShipping['driverName'],
      chasisPatent: jsonShipping['chasisPatent'],
      remiterFullWeight: jsonShipping['remiterFullWeight'],
      remiterFullWeightTime: DateTime.tryParse(jsonShipping['remiterFullWeightTime']),
      remiterFullWeightUser: jsonShipping['remiterFullWeightUser'],
      remiterLocation: jsonShipping['remiterLocation'],
      remiterTara: jsonShipping['remiterTara'],
      remiterTaraTime: DateTime.tryParse(jsonShipping['remiterTaraTime']),
      remiterTaraUser: jsonShipping['remiterTaraUser'],
      reciverFullWeight: jsonShipping['reciverFullWeight'],
      reciverFullWeightTime: DateTime.tryParse(jsonShipping['reciverFullWeightTime']),
      reciverFullWeightUser: jsonShipping['reciverFullWeightUser'],
      reciverLocation: jsonShipping['reciverLocation'],
      reciverTara: jsonShipping['reciverTara'],
      reciverTaraTime: DateTime.tryParse(jsonShipping['reciverTaraTime']),
      reciverTaraUser: jsonShipping['reciverTaraUser'],
      riceType: jsonShipping['riceType'],
      id: jsonShipping['id'],
      crop: jsonShipping['crop'],
      departure: jsonShipping['departure'],
      humidity: jsonShipping['humidity'],
      actions: json.decode(jsonShipping['actions'] ?? '[]'),
      userActions: json.decode(jsonShipping['userActions'] ?? '[]'),
      dateActions: json.decode(jsonShipping['dateActions'] ?? '[]'),
      reciverDryWeight: jsonShipping['reciverDryWeight'],
      reciverWetWeight: jsonShipping['reciverWetWeight'],
      remiterDryWeight: jsonShipping['remiterDryWeight'],
      remiterWetWeight: jsonShipping['remiterWetWeight'],
      isOnLine: json.decode(jsonShipping['isOnLine'] ?? 'true'),
      lote: jsonShipping['lote'],
    );
  }

  Map<String, String> toJson(){
    Map<String, String> jsonShipping = {
      "shippingState": getStatus,
      "truckPatent": truckPatent,
      "driverName": driverName,
      "chasisPatent": chasisPatent,
      "remiterFullWeight": remiterFullWeight ?? '',
      "remiterFullWeightTime": remiterFullWeightTime.toString(),
      "remiterFullWeightUser": remiterFullWeightUser ?? '',
      "remiterLocation": remiterLocation ?? '',
      "remiterTara": remiterTara ?? '',
      "remiterTaraTime": remiterTaraTime.toString(),
      "remiterTaraUser": remiterTaraUser ?? '',
      "reciverFullWeight": reciverFullWeight ?? '',
      "reciverFullWeightTime": reciverFullWeightTime.toString(),
      "reciverFullWeightUser": reciverFullWeightUser ?? '',
      "reciverLocation": reciverLocation ?? '',
      "reciverTara": reciverTara ?? '',
      "reciverTaraTime": reciverTaraTime.toString(),
      "reciverTaraUser": reciverTaraUser ?? '',
      "riceType": riceType ?? '',
      "id": id ?? '',
      "crop": crop ?? '',
      "departure": departure ?? '',
      "humidity": humidity ?? '',
      "actions": json.encode(actions),
      "userActions": json.encode(userActions),
      "dateActions": json.encode(dateActions),
      "reciverDryWeight": reciverDryWeight ?? '',
      "reciverWetWeight": reciverWetWeight ?? '',
      "remiterDryWeight": remiterDryWeight ?? '',
      "remiterWetWeight": remiterWetWeight ?? '',
      "isOnLine": json.encode(isOnLine),
      "lote": lote ?? '',
    };
    return jsonShipping;
  }

  @override
  List<Object?> get props => [this.remiterTaraTime, this.driverName, this.remiterTara, this.shippingState, this.isOnLine];
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