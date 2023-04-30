import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

class User{
  String login = '';
  String password = '';
}

void main() async{
  runApp(const loginPage());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}

class loginPage extends StatelessWidget 
{
  const loginPage({super.key});


  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Authorization app',
      theme: ThemeData(primarySwatch: Colors.red,),
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
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Поле не должно быть пустым!';
              }
              else{
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
              }
              else{
                inputUser.password = value;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) 
                {
                  try {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: inputUser.login,
                        password: inputUser.password
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }; 
                  }
              },
              child: const Text('Войти'),
            ),
          ),
          ElevatedButton(
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => regPage())); },
              child: const Text('Зарегистрироваться'),
          ),
        ],
      ),
    );
  }
}

class regPage extends StatelessWidget 
{
  const regPage({super.key});


  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
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

  var inputUser = User();
  String passwd = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Поле не должно быть пустым!';
              }
              else{
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
              }
              else{
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
              }
              else if(value == passwd){
                inputUser.password = value;
              }
              else if(value != passwd){
                return 'Пароли не совпадают!';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) 
                {
                  try {
                        FirebaseAuth.instance.createUserWithEmailAndPassword
                        (
                          email: inputUser.login,
                          password: inputUser.password,
                        );
                      } on FirebaseAuthException catch (e) 
                      {
                        if (e.code == 'weak-password') 
                        {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') 
                        {
                          print('The account already exists for that email.');
                        }
                      } catch (e) 
                      {
                        print(e);
                      }
                      
                      print(inputUser.login);
                      print(inputUser.password);}
                      },
              child: const Text('Зарегистрироваться'),
            ),
          ),
        ],
      ),
    );
  }
}


