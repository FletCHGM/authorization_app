import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class User {
  String login = '';
  String password = '';
}

void UserAlert(text, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(text),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"))
        ],
      );
    },
  );
}

////
var currentUser = FirebaseAuth.instance.currentUser;

var storageRef = FirebaseStorage.instance.ref();
var imagesRef = storageRef.child("/images");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickture App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Scaffold(
        body: ImageList(),
      ),
    );
  }
}

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  Future getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      if (imageFile != null) {
        uploadImage(imageFile);
      }
    }
  }

  Future getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      File imageFile = File(image.path);
      if (imageFile != null) {
        uploadImage(imageFile);
      }
    }
  }

  void uploadImage(File image) async {
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

  List<Image>? _imagesList;
  @override
  Widget build(BuildContext context) {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Картинки'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () async {
                List<Image> images = await getFirebaseImages();
                _imagesList = images;
                setState(() {});
              },
              child: const Icon(Icons.refresh),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Icon(Icons.login))
          ],
        ),
        body: (_imagesList == null)
            ? SizedBox()
            : ListView.builder(
                itemBuilder: (context, i) => _imagesList![i],
                itemCount: _imagesList!.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Загрузить фотографию"),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          await getImageFromGallery();
                        },
                        child: const Text("Выбрать из галереи")),
                    ElevatedButton(
                        onPressed: () async {
                          await getImageFromCamera();
                        },
                        child: const Text("Сфотографировать"))
                  ],
                );
              },
            );
          },
          child: const Text('+'),
        ),
      );
    } else {
      return AlertDialog(
        title: const Text("Войдите в свой аккаунт"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Войти"))
        ],
      );
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickture App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Вход'),
          centerTitle: true,
        ),
        body: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var inputUser = User();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else {
                  inputUser.login = value;
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else {
                  inputUser.password = value;
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  var authState = '';
                  if (_formKey.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: inputUser.login,
                              password: inputUser.password);
                      authState = 'Succes';
                    } on FirebaseAuthException catch (e) {
                      authState = e.code;
                      print("$authState&&");
                    }
                  }
                  ;
                  switch (authState) {
                    case 'user-not-found':
                      UserAlert("Пользователя ${inputUser.login} не существует",
                          context);
                      break;
                    case 'wrong-password':
                      UserAlert("Неправильный пароль", context);
                      break;
                    case 'invalid-email':
                      UserAlert("Пользователя ${inputUser.login} не существует",
                          context);
                      break;
                    case 'Succes':
                      currentUser = FirebaseAuth.instance.currentUser;
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                      break;
                  }
                },
                child: const Text('Войти'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => RegPage()));
              },
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegPage extends StatelessWidget {
  const RegPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зарегистрироваться'),
        centerTitle: true,
      ),
      body: const RegForm(),
    );
  }
}

class RegForm extends StatefulWidget {
  const RegForm({super.key});

  @override
  State<RegForm> createState() => RegFormState();
}

class RegFormState extends State<RegForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String passwd = '';
  @override
  Widget build(BuildContext context) {
    var inputUser = User();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else {
                  inputUser.login = value;
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else {
                  passwd = value;
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Подтвердите пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else if (value == passwd) {
                  inputUser.password = value;
                } else if (value != passwd) {
                  return 'Пароли не совпадают!';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var regState = '';
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: inputUser.login,
                        password: inputUser.password,
                      );
                    } on FirebaseAuthException catch (e) {
                      regState = e.code;
                    } catch (e) {
                      print(e);
                    }
                    switch (regState) {
                      case "weak-password":
                        UserAlert("Ваш пароль слишком простой", context);
                        break;
                      case "email-already-in-use":
                        UserAlert(
                            "Аккаунт ${inputUser.login} уже зарегистрирован",
                            context);
                        break;
                      default:
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                        UserAlert(
                            "Вы успешно зарегистрировали аккаунт ${inputUser.login}",
                            context);
                        break;
                    }
                  }
                },
                child: const Text('Зарегистрироваться'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
