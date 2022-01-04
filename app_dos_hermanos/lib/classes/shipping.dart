import 'package:cloud_firestore/cloud_firestore.dart';

class Shipping {
  final String patent, id;
  final String? remiterTara, remiterFullWeight, reciverTara, reciverFullWeight;
  final String? remiterTaraTime, remiterFullWeightTime, reciverTaraTime, reciverFullWeightTime;
  final String? remiterTaraUser, remiterFullWeightUser, reciverTaraUser, reciverFullWeightUser;
  final String? remiterLocation, reciverLocation;
  final String? riceType;

  Shipping({
    required this.patent, required this.id,
    this.remiterTara, this.remiterFullWeight, this.reciverTara, this.reciverFullWeight, 
    this.remiterTaraTime, this.remiterFullWeightTime, this.reciverTaraTime, this.reciverFullWeightTime, 
    this.remiterTaraUser, this.remiterFullWeightUser, this.reciverTaraUser, this.reciverFullWeightUser, 
    this.remiterLocation, this.reciverLocation, 
    this.riceType
  });

  static Shipping fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Shipping(
      patent: data['patent'],
      id: snapshot.id
    );
  }
}