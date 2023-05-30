import '../repos_view.dart';

class UserAlert {
  void userAlert(String text, BuildContext context) {
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

  void loginErrorAlerts(String authState, BuildContext context) {
    switch (authState) {
      case 'user-not-found':
        userAlert("Такого пользователя не существует", context);
        break;
      case 'wrong-password':
        userAlert("Неправильный пароль", context);
        break;
      case 'invalid-email':
        userAlert("Такого пользователя не существует", context);
        break;
      default:
        break;
    }
  }

  void regErrorAlerts(String regState, BuildContext context) {
    switch (regState) {
      case "weak-password":
        UserAlert().userAlert("Ваш пароль слишком простой", context);
        break;
      case "email-already-in-use":
        UserAlert().userAlert("Такой аккаунт уже зарегистрирован", context);
        break;
      default:
        UserAlert().userAlert("Вы успешно зарегистрировали аккаунт", context);
        break;
    }
  }
}
