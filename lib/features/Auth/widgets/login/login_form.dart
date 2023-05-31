import '../widget_view.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final login = TextEditingController();
  final passwd = TextEditingController();
  final _authBloc = AuthBloc();
  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: _authBloc,
      builder: (context, state) {
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
                      } else {
                        return null;
                      }
                    }),
                TextFormField(
                    controller: passwd,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      suffixIcon: IconButton(
                          icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Поле не должно быть пустым!';
                      } else {
                        return null;
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _authBloc
                            .add(TryToLogin(login.text, passwd.text, context));
                      }
                      if (state is AuthFailure) {
                        UserAlert().loginErrorAlerts(state.error!, context);
                      } else {}
                    },
                    child: (state is AuthLoadig)
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.5,
                          )
                        : const Text('Вход'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const RegPage()));
                  },
                  child: const Text('Зарегистрироваться'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
