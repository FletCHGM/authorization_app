import 'widgets_view.dart';

class ImageList extends StatefulWidget {
  const ImageList({super.key});

  @override
  State<ImageList> createState() => ImageListState();
}

class ImageListState extends State<ImageList> {
  final scrollController = ScrollController();
  final _imagesBloc = ImagesBloc();
  List<Hero> _imagesList = [];
  List<String> paths = [];

  void refresh() {
    setState(() {
      _imagesList.clear();
    });
    _imagesBloc.add(FirstTryToLoadImages(context));
  }

  @override
  void initState() {
    super.initState();
    _imagesBloc.add(FirstTryToLoadImages(context));
    setState(() {});
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        _imagesBloc.add(TryToLoadImages(context, paths));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseImagePicker().currentUser() != null) {
      return BlocBuilder<ImagesBloc, ImagesState>(
        bloc: _imagesBloc,
        builder: (context, state) {
          if (state is ImagesLoaded) {
            _imagesList.addAll(state.list);
            paths = state.paths;
          }
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
            body: (!_imagesList.isEmpty)
                ? RefreshIndicator(
                    child: (state is ImagesFailure)
                        ? Center(
                            child: Text('Что-то пошло не так'),
                          )
                        : GridView.builder(
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
                                if (!(state is AllImagesLoaded)) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return null;
                                }
                              }
                            },
                            itemCount: (_imagesList.length) + 1),
                    onRefresh: () async {
                      refresh();
                    })
                : const Center(child: CircularProgressIndicator()),
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
        },
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
