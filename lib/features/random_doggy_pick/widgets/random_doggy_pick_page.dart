import 'widgets_view.dart';

class RandomPickPage extends StatelessWidget {
  const RandomPickPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Случайная картинка с собакой'),
        centerTitle: true,
      ),
      body: const RandomPickBody(),
    );
  }
}
