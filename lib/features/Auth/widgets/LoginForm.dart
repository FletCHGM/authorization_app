import 'widgetView.dart'; //файл экспорта необходимых зависимостей

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
