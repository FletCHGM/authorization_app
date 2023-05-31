import 'package:authorization_app/features/auth/widgets/widget_view.dart';

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
                  },
                ),
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
                  },
                ),
                TextFormField(
                  controller: confirmPasswd,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: 'Подтвердите пароль',
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
                        _authBloc
                            .add(TryToReg(login.text, passwd.text, context));
                      }
                    },
                    child: (state is AuthLoadig)
                        ? const CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.5,
                          )
                        : const Text('Зарегистрироваться'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
