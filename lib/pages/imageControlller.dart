import 'package:flutter/material.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:myboardapp/boxes.dart';

var boxofImages = BoxofImage.getImages();

class ImageController with ChangeNotifier {
  late m.Images _myimage;
  ImageController() {
    _myimage = m.Images(
      imagesource: '_',
    );
  }

  m.Images get Image => _myimage;

  void setImage(m.Images Image) {
    _myimage = Image;
    notifyListeners();
  }

  void addImage(m.Images Image) {
    boxofImages.add(Image);
    notifyListeners();
  }

  void removeImage(ImageKey) {
    boxofImages.delete(ImageKey);
    notifyListeners();
  }

  void emptyImage() async {
    await boxofImages.clear();
    notifyListeners();
  }
}
