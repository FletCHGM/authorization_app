import 'view.dart'; //файл экспорта необходимых зависимостей

var storageRef = FirebaseStorage.instance.ref();
var imagesRef = storageRef.child("/images");

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
  var name = '';
  currentUser = FirebaseAuth.instance.currentUser;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.file(image),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  DateTime CurrentTime = new DateTime.now();
                  var imageRef = imagesRef.child(
                      '/${currentUser?.email.toString()}_${CurrentTime.toString()}');
                  var state = 1;
                  try {
                    await imageRef.putFile(image);
                  } on PlatformException catch (e) {
                    state = 0;
                  }
                  if (state == 1) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } else {
                    UserAlert('Ошибка загрузки', context);
                  }
                },
                child: const Text('Отправить фото'))
          ],
        );
      });
}

Future<List<Image>> getFirebaseImages() async {
  var imagesList = await imagesRef.listAll();
  var imagesReference = imagesList.items;
  var paths = [];
  List<Image> images = [];
  for (var i in imagesReference) {
    var ImagesPath = i.fullPath;
    paths.add(ImagesPath);
  }
  for (var i in paths) {
    var imageRawFile = await storageRef.child(i).getData();
    var imageFile = Image.memory(imageRawFile as Uint8List);
    images.add(imageFile);
  }
  return images;
}
