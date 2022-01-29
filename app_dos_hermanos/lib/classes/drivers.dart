class Driver {
  Driver({
    required this.code,
    required this.active,
    required this.name,
    required this.patent,
    required this.chasisPatent,
    required this.company,
  });

  final String code;
  final bool active;
  final String name;
  String patent;
  String chasisPatent;
  String company;

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      code: json["codigo"] ?? '',
      active: json["activo"] ?? '',
      name: json["nombre"] ?? '',
      patent: json["patente"] ?? '',
      chasisPatent: json["patenteAcoplado"] ?? '',
      company: json["transportista"] ?? '',
    );
  }

  Driver copyWith({
    String? code,
    bool? active,
    String? name,
    String? patent,
    String? chasisPatent,
    String? company,
  }){
    return Driver(
      code: code ?? this.code,
      active: active ?? this.active,
      name: name ?? this.name,
      patent: patent ?? this.patent,
      chasisPatent: chasisPatent ?? this.chasisPatent,
      company: company ?? this.company,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      "Codigo": code,
      "Activo": active,
      "Nombre": name,
      "Patente": patent,
      "PatenteAcoplado": chasisPatent,
      "Transportista": company,
    };
  }
}