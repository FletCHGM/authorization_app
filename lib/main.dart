import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ...

class User {
  String login = '';
  String password = '';
}

var inputUser = User();
var storageRef = FirebaseStorage.instance.ref();
var imagesRef = storageRef.child("/images");
void main() async {
  runApp(const loginPage());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authorization app',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Autorization Page'),
          centerTitle: true,
        ),
        body: loginForm(),
      ),
    );
  }
}

class loginForm extends StatefulWidget {
  const loginForm({super.key});

  @override
  State<loginForm> createState() => loginFormState();
}

class loginFormState extends State<loginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var inputUser = User();

  @override
  Widget build(BuildContext context) {
    return Form(
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
                var authState = "";
                if (_formKey.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: inputUser.login,
                            password: inputUser.password);
                  } on FirebaseAuthException catch (e) {
                    authState = e.code;
                  }
                }
                ;
                switch (authState) {
                  case 'user-not-found':
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                              "Пользователя ${inputUser.login} не существует"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"))
                          ],
                        );
                      },
                    );
                    break;
                  case 'wrong-password':
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Неправильный пароль"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"))
                          ],
                        );
                      },
                    );
                    break;
                  default:
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => imagePage()));
                    break;
                }
              },
              child: const Text('Войти'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => regPage()));
            },
            child: const Text('Зарегистрироваться'),
          ),
        ],
      ),
    );
  }
}

class regPage extends StatelessWidget {
  const regPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        centerTitle: true,
      ),
      body: regForm(),
    );
  }
}

class regForm extends StatefulWidget {
  const regForm({super.key});

  @override
  State<regForm> createState() => regFormState();
}

class regFormState extends State<regForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String passwd = '';
  @override
  Widget build(BuildContext context) {
    return Form(
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
                    final credential = await FirebaseAuth.instance
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Ваш пароль слишком простой"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"))
                            ],
                          );
                        },
                      );
                      break;
                    case "email-already-in-use":
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Аккаунт ${inputUser.login} уже зарегистрирован"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"))
                            ],
                          );
                        },
                      );
                      break;
                    default:
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => loginPage()));
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                "Вы успешно зарегистрировали аккаунт ${inputUser.login}"),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Ok"))
                            ],
                          );
                        },
                      );
                      break;
                  }
                  print(inputUser.login);
                  print(inputUser.password);
                }
              },
              child: const Text('Зарегистрироваться'),
            ),
          ),
        ],
      ),
    );
  }
}

class imagePage extends StatefulWidget {
  const imagePage({super.key});

  @override
  State<imagePage> createState() => imagePageState();
}

class imagePageState extends State<imagePage> {
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.file(image),
            actions: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Введите название фотографии',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Поле не должно быть пустым!';
                  } else {
                    name = value;
                  }
                  return null;
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    var imageRef = imagesRef.child('/${inputUser.login}_$name');
                    print('$imageRef----');
                    try {
                      await imageRef.putFile(image);
                    } on PlatformException catch (e) {
                      print('Failed to pick image');
                    }
                    ;
                  },
                  child: Text('Отправить фото'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Загруженные картинки"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Загрузить фотографию"),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        await getImageFromGallery();
                      },
                      child: Text("Выбрать из галереи")),
                  ElevatedButton(
                      onPressed: () async {
                        await getImageFromCamera();
                      },
                      child: Text("Сфотографировать"))
                ],
              );
            },
          );
        },
        child: Text('+'),
      ),
    );
  }
}
