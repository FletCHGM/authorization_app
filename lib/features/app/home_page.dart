//файл экспорта необходимых зависимостей
import 'app_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickture App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 208, 208),
      ),
      home: const Scaffold(
        body: ImageList(),
      ),
    );
  }
}
