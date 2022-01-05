import 'package:cloud_firestore/cloud_firestore.dart';

enum ShippingState{newShipping, loadingShipping, inTravelShiping, downloadedShipping}

class Shipping {
  String patent;
  ShippingState shippingState;
  String? id;
  String? remiterTara, remiterFullWeight, reciverTara, reciverFullWeight;
  String? remiterTaraTime, remiterFullWeightTime, reciverTaraTime, reciverFullWeightTime;
  String? remiterTaraUser, remiterFullWeightUser, reciverTaraUser, reciverFullWeightUser;
  String? remiterLocation, reciverLocation;
  String? riceType;

  Shipping({
    required this.shippingState,
    required this.patent, this.id,
    this.remiterTara, this.remiterFullWeight, this.reciverTara, this.reciverFullWeight, 
    this.remiterTaraTime, this.remiterFullWeightTime, this.reciverTaraTime, this.reciverFullWeightTime, 
    this.remiterTaraUser, this.remiterFullWeightUser, this.reciverTaraUser, this.reciverFullWeightUser, 
    this.remiterLocation, this.reciverLocation, 
    this.riceType
  });

  static Shipping fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Shipping(
      shippingState: data['shippingState'],
      patent: data['patent'],
      id: snapshot.id,
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
}