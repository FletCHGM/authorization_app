import 'widgetsView.dart'; //файл экспорта необходимых зависимостей

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  List<Image>? _imagesList;

  @override
  Widget build(BuildContext context) {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Картинки'),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: () async {
                List<Image> images = await getFirebaseImages();
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
            ? SizedBox()
            : ListView.builder(
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
                          await getImageFromGallery(context);
                        },
                        child: const Text("Выбрать из галереи")),
                    ElevatedButton(
                        onPressed: () async {
                          await getImageFromCamera(context);
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
