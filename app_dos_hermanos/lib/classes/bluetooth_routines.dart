import 'dart:convert';
import 'dart:typed_data';

class BluetoothRoutines {
  static Uint8List btSendBuffer(String comand, String patent, String date){
    return Uint8List.fromList(
      [0x02]
      + utf8.encode(comand).toList()
      + utf8.encode(patent).toList()
      + [0x0D, 0x0A]
      + utf8.encode(date).toList()
      + [0x0D, 0x0A]
      + [0x03]
    );
  }
}