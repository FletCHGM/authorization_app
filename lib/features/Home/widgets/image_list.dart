import 'widgets_view.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  List<Hero>? _imagesList;
  var isSuccess = false;
  @override
  Widget build(BuildContext context) {
    if (FirebaseImagePicker().currentUser() != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Картинки'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () async {
                List<Hero> images = await ImageHero().imageHero(context);
                _imagesList = images;
                setState(() {});
              },
              child: const Icon(Icons.refresh),
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Icon(Icons.login))
          ],
        ),
        body: (_imagesList == null)
            ? SizedBox(
                child: Center(
                    child: Text(
                "Обновите страницу",
                textScaleFactor: 2.4,
              )))
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, i) => _imagesList![i],
                itemCount: _imagesList!.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Загрузить фотографию"),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseImagePicker()
                              .getImageFromGallery(context);
                        },
                        child: const Text("Выбрать из галереи")),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseImagePicker()
                              .getImageFromCamera(context);
                        },
                        child: const Text("Сфотографировать"))
                  ],
                );
              },
            );
          },
          child: const Text('+'),
        ),
      );
    } else {
      return AlertDialog(
        title: const Text("Войдите в свой аккаунт"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text("Войти"))
        ],
      );
    }
  }
}
