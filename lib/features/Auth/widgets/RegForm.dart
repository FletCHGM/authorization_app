import 'widgetView.dart'; //файл экспорта необходимых зависимостей

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
    var inputUser = InputUser();
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
