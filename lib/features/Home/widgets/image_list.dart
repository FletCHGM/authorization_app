import 'widgets_view.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  final scrollController = ScrollController();
  bool isSuccess = false;
  bool isLoading = true;
  int _countOfPacks = 0;
  List<Hero> images = [];
  List<Hero> _imagesList = [];
  Future<void> _pickImagesList() async {
    images = await ImageHero().imageHero(context, _countOfPacks);
    _imagesList.addAll(images);
  }

  @override
  void initState() {
    _imagesList = [];
    _countOfPacks = 0;
    isLoading = true;
    _pickImagesList();
    setState(() {});
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (!images.isEmpty) {
          _countOfPacks++;
          _pickImagesList();
          setState(() {});
        } else {
          isLoading = false;
        }
      }
    });
  }

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
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Icon(Icons.login))
          ],
        ),
        body: (_imagesList.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                child: GridView.builder(
                    controller: scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, i) {
                      if (i < _imagesList!.length) {
                        return _imagesList![i];
                      } else {
                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }
                    },
                    itemCount: (_imagesList!.length) + 1),
                onRefresh: () async {
                  _countOfPacks = 0;
                  await _pickImagesList();
                  _imagesList.clear;
                  setState(() {});
                }),
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
