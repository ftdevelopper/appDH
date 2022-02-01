class Rice {
  final String type;

  Rice({required this.type});

  factory Rice.fromJson(Map<String, dynamic> json){
    return Rice(
      type: json["type"]
    );
  }

  Map<String, String> toJson(){
    return {
      "type":type,
    };
  }

  double getDryWeight({required double humidity, required double weight}){
    double dryWeight = 0;
    if (humidity <= 13){
      dryWeight = weight;
    } else if (13 < humidity && humidity < 32.0){
      dryWeight = weight * (1 + (humidity * 0.12 + 0.845));
    }
    return dryWeight;
  }
}