import '../repos_view.dart';

final Reference storageRef = FirebaseStorage.instance.ref();
final Reference imagesRef = storageRef.child("/images");

class FirebaseImagePicker {
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> getImageFromGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      uploadImage(imageFile, context);
    }
  }

  Future<void> getImageFromCamera(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      uploadImage(imageFile, context);
    }
  }

  void uploadImage(File image, BuildContext context) async {
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
                    } on PlatformException {
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

  List<String> getFirebaseImagesPaths(ListResult items) {
    var imagesReference = items.items;
    List<String> paths = [];
    Reference i;
    for (i in imagesReference) {
      paths.add(i.fullPath);
    }
    return paths;
  }

  Future<List<String>> getFirebaseImagesURLs(List<String> paths) async {
    List<String> URLs = [];
    for (var i in paths) {
      if (URLs.length < 28) {
        var imageURL = await storageRef.child(i).getDownloadURL();
        URLs.add(imageURL);
      } else {
        break;
      }
    }
    print(URLs.length);
    return URLs;
  }
}
