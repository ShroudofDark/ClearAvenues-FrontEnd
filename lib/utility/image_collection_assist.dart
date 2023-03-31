import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

ImagePicker picker = ImagePicker();
List<XFile> imageFileList = []; //For multi-images + gallery
XFile? cameraImage;

void selectImagesGallery() async {
  final List<XFile> selectedImages = await picker.pickMultiImage();
  if (selectedImages!.isNotEmpty) {
    imageFileList!.addAll(selectedImages);
  }
}

void selectImagesCamera() async {
  final XFile? selectedImage = await picker.pickImage(source: ImageSource.camera);
  if (selectedImage != null) {
    cameraImage = selectedImage;
  }
}