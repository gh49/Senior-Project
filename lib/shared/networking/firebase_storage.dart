import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';

class G49Storage {
  static Reference storageRef = FirebaseStorage.instance.ref();

  static Future<String> uploadBytes(Uint8List bytes, String name) async {
    String mime = getMime(bytes);
    TaskSnapshot file = await storageRef.child("images/$name.${getExtension(mime)}").putData(bytes, SettableMetadata(contentType: mime));
    String? url = await file.ref.getDownloadURL();
    return url;
  }

  static String getMime(Uint8List bytes) {
    String mime = lookupMimeType('', headerBytes: bytes) ?? "image/png";
    print(mime);
    return mime;
  }

  static String getExtension(String mime) {
    for(int i=0; i<mime.length; i++) {
      if(mime[i] == "/") {
        return mime.substring(i+1);
      }
    }
    return "png";
  }

}