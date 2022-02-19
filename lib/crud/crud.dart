import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/API-provider.dart';
import 'package:image_picker/image_picker.dart';

final picker = ImagePicker();
File? file;
final titleController = TextEditingController();
final priceController = TextEditingController();
final messageController = TextEditingController();
final tagController = TextEditingController();
addDataWidget(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 500,
          width: 50,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Add title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              ElevatedButton.icon(
                onPressed: () => _getImage(ImageSource.camera),
                icon: const Icon(Icons.image),
                label: const Text('gallery'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      await Provider.of<TodoProvider>(context, listen: false)
                          .addData({
                        "title": titleController.text,
                        "price": priceController.text,
                        "message": messageController.text,
                        "tags": tagController.text,
                        "selectedFile": await _getImage(ImageSource.camera)
                      }).whenComplete(() => Navigator.pop(context));
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text('Message'),
                                content: Text('Your file is Added.'),
                              )).whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: const Text("Submit"))
            ],
          )));
}

_getImage(ImageSource imageSource) async {
  var imageFile = (await picker.pickImage(source: imageSource));
  if (imageFile == null) return '';
//Rebuild UI with the selected image.
  var _image = File(imageFile.path);

  final imageBytes = _image.readAsBytesSync();
  print(imageBytes);
  String image = base64.encode(imageBytes);
  print(image);
  return image;

  // Uint8List _bytes = Uint8List.fromList(imageBytes);
  // return _bytes;
}

updateDataWidget(BuildContext context, String id, String title, String price,
    String message, String tags, String selectedFile) {
  titleController.text = title;
  priceController.text = price;
  messageController.text = message;
  tagController.text = tags;
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 500,
          width: 500,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Add title'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(hintText: 'Add description'),
              ),
              // TextField(
              //   controller: selectedController,
              //   decoration: const InputDecoration(hintText: 'Add description'),
              // ),
              ElevatedButton.icon(
                // onPressed: () => _getImage(ImageSource.camera),
                onPressed: () {},
                icon: const Icon(Icons.image),
                label: const Text('gallery'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isNotEmpty) {
                      Provider.of<TodoProvider>(context, listen: false)
                          .updateData({
                        'id': id,
                        "title": titleController.text,
                        "price": priceController.text,
                        "message": messageController.text,
                        "tags": tagController.text,
                        // "selectedFile":await _getImage(ImageSource.camera),
                      }, id).whenComplete(() => Navigator.pop(context));
                      showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                                title: Text('Message'),
                                content: Text('Your file is Added.'),
                              )).whenComplete(() => Navigator.pop(context));
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: const Text('Updated',
                          style: TextStyle(fontSize: 15)))),
            ],
          )));
}

deleteDataWidget(BuildContext context, String id) {
  return showModalBottomSheet(
      context: context,
      builder: (context) => Container(
          height: 200,
          width: 50,
          alignment: Alignment.center,
          child: Center(
              child: Column(
            children: <Widget>[
              const Center(
                child: ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Click Yes To Delete Items')),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Yes'),
                onTap: () {
                  Provider.of<TodoProvider>(context, listen: false)
                      .deleteData(id)
                      .whenComplete(() => Navigator.pop(context));
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('Message'),
                            content: Text('Your file is Deleted.'),
                          )).whenComplete(() => Navigator.pop(context));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('No'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('Message'),
                            content: Text('Your file is not Deleted.'),
                          )).whenComplete(() => Navigator.pop(context));
                },
              ),
            ],
          ))));
}
