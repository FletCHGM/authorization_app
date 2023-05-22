import '../widget_view.dart';

class RegForm extends StatefulWidget {
  const RegForm({super.key});

  @override
  State<RegForm> createState() => RegFormState();
}

class RegFormState extends State<RegForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final login = TextEditingController();
  final passwd = TextEditingController();
  final confirmPasswd = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: login,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                }
              },
            ),
            TextFormField(
              controller: passwd,
              decoration: const InputDecoration(
                hintText: 'Пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                }
              },
            ),
            TextFormField(
              controller: confirmPasswd,
              decoration: const InputDecoration(
                hintText: 'Подтвердите пароль',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Поле не должно быть пустым!';
                } else if (value != passwd.text) {
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
                        email: login.text,
                        password: passwd.text,
                      );
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    } on FirebaseAuthException catch (e) {
                      regState = e.code;
                    }
                    UserAlert().regErrorAlerts(regState, context);
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
