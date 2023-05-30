import 'package:authorization_app/features/auth/widgets/widget_view.dart';

class RegPage extends StatelessWidget {
  const RegPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зарегистрироваться'),
        centerTitle: true,
      ),
      body: const RegForm(),
    );
  }
}
