import 'model_view.dart';

final Reference storageRef = FirebaseStorage.instance.ref();
final Reference imagesRef = storageRef.child("/images");

class FirebaseImagePicker {
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future getImageFromGallery(context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      if (imageFile != null) {
        uploadImage(imageFile, context);
      }
    }
  }

  Future getImageFromCamera(context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      if (imageFile != null) {
        uploadImage(imageFile, context);
      }
    }
  }

  void uploadImage(File image, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.file(image),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    DateTime CurrentTime = DateTime.now();
                    var user = currentUser();
                    var imageRef = imagesRef.child(
                        '/${user?.email.toString()}_${CurrentTime.toString()}');
                    var state = false;
                    try {
                      await imageRef.putFile(image);
                      state = true;
                    } on PlatformException catch (e) {
                      state = false;
                    }
                    if (state == true) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      UserAlert().userAlert('Ошибка загрузки', context);
                    }
                  },
                  child: const Text('Отправить фото'))
            ],
          );
        });
  }

  Future<List> getFirebaseImages() async {
    var imagesList = await imagesRef.listAll();
    var imagesReference = imagesList.items;
    var paths = [];
    List images = [];
    for (var i in imagesReference) {
      var imagesPath = i.fullPath;
      paths.add(imagesPath);
    }
    for (var i in paths) {
      var imageURL = await storageRef.child(i).getDownloadURL();
      images.add(imageURL);
      print(imageURL);
    }
    return images;
  }
}
