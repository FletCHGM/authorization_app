import 'view.dart'; //файл экспорта необходимых зависимостей

class InputUser {
  String login = '';
  String password = '';
}

var currentUser = FirebaseAuth.instance.currentUser;
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
