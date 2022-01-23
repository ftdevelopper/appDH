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
}