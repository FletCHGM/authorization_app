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
  List<Hero> images = [];
  List<Hero> _imagesList = [];
  List<String>? URLs;
  List<String> paths = [];
  ListResult? items;

  void pickImages() async {
    URLs = await FirebaseImagePicker().getFirebaseImagesURLs(paths);
    var i = URLs!.length;
    while (i > 0) {
      paths.remove(paths.first);
      i--;
    }
    List<Hero> pickedImages = ImageHero().imageHero(context, URLs!);
    if (!pickedImages.isEmpty) {
      for (var i in pickedImages) {
        _imagesList.add(i);
      }
    } else {
      isLoading = false;
    }
    setState(() {});
  }

  void _pickImagesToInit() async {
    items = await imagesRef.listAll();
    paths = await FirebaseImagePicker().getFirebaseImagesPaths(items!);
    URLs = await FirebaseImagePicker().getFirebaseImagesURLs(paths);
    _imagesList = ImageHero().imageHero(context, URLs!);
    var i = URLs!.length;
    while (i > 0) {
      paths.remove(paths.first);
      i--;
    }
    setState(() {});
  }

  void refresh() {
    setState(() {
      _imagesList.clear();
      isLoading = true;
    });
    _pickImagesToInit();
  }

  @override
  void initState() {
    _pickImagesToInit();
    print(_imagesList.length);
    isLoading = true;
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        pickImages();
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RandomPickPage()));
                },
                child: const Icon(Icons.emoji_nature)),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                child: const Icon(Icons.login)),
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
                      if (i < _imagesList.length) {
                        return _imagesList[i];
                      } else {
                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SizedBox();
                        }
                      }
                    },
                    itemCount: (_imagesList.length) + 1),
                onRefresh: () async {
                  refresh();
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
          child: const Icon(Icons.upload),
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
