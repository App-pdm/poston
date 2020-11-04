import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:translator/translator.dart';

class Translator {
  String text = "Tire uma foto do texto que deseja traduzir.";

  Future<PickedFile> pickImage() async =>
      await ImagePicker().getImage(source: ImageSource.camera);

  Future<String> readTextFromImage(PickedFile imageFile) async {
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(File(imageFile.path));
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText visionText = await recognizeText.processImage(ourImage);
    return visionText.text;
  }

  Future<String> translate(String text) async {
    GoogleTranslator translator = GoogleTranslator();
    Translation translation = await translator.translate(text, to: 'pt');
    return translation.text;
  }

  translateTextImage() async {
    var pickedFile = await pickImage();
    var originalText = await readTextFromImage(pickedFile);
    var translatedText = await translate(originalText);

    return translatedText.toString();
  }
}
