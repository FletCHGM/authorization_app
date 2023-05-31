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
  String? result;
  bool _passwordVisible = false;

  String? loginSwitch(BuildContext context, String login, String passwd) {
    _authBloc.add(TryToLogin(login, passwd, context));
    final state = _authBloc.state;
    return switch (state) {
      AuthSuccess() => 'success',
      AuthFailure() => 'fail',
      AuthLoadig() => 'loading',
      AuthInitial() => null,
    };
  }

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
                        loginSwitch(context, login.text, passwd.text);
                      }
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
