import 'widgets_view.dart';

class RandomPickBody extends StatefulWidget {
  const RandomPickBody({super.key});

  @override
  State<RandomPickBody> createState() => RandomPickBodyState();
}

class RandomPickBodyState extends State<RandomPickBody> {
  String? pick;

  @override
  void initState() {
    super.initState();
    getDoggyPick();
  }

  void getDoggyPick() async {
    pick = await ApiResponse().randDoggyPick();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (pick == null)
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SizedBox(
                child: Image.network(
                  pick!,
                  fit: BoxFit.fill,
                ),
                width: 500,
              )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              pick = null;
            });
            getDoggyPick();
          },
          child: const Icon(Icons.refresh),
        ));
  }
}
