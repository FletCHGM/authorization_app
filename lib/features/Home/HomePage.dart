import 'imagesView.dart'; //файл экспорта необходимых зависимостей

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pickture App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Scaffold(
        body: ImageList(),
      ),
    );
  }
}
