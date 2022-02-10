class Lote {
  final String riceType;
  final String lote;

  Lote({required this.riceType, required this.lote});

  factory Lote.fromJson(Map<String, dynamic> json){
    return Lote(
      riceType: json["variedad"],
      lote: json["lote"].toString()
    );
  }

  Map<String, String> toJson(){
    return {
      "variedad":riceType,
      "lote": lote,
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