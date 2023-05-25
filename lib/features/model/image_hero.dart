import '../Home/widgets/widgets_view.dart';

class ImageHero {
  pickImageList(int page) async {
    List paths = await FirebaseImagePicker().getFirebaseImagesPaths(page);
    List URLs = await FirebaseImagePicker().getFirebaseImagesURLs(paths);
    return URLs;
  }

  imageHero(BuildContext context, int page) async {
    List<Hero> miniHeroList = [];
    List<Hero> heroList = [];
    int i;
    String image;
    List URLs = await pickImageList(page);
    if (URLs.isEmpty) {
      List<Hero> emptyList = [];
      return emptyList;
    }
    for (image in URLs) {
      Hero heroFullImage = Hero(
          tag: image,
          child: Scaffold(
            appBar: AppBar(),
            body: Image.network(image),
          ));
      heroList.add(heroFullImage);
      Hero heroSmallImage = Hero(
          tag: image,
          child: Material(
              child: InkWell(
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Material(child: heroFullImage)));
                  })));
      miniHeroList.add(heroSmallImage);
    }
    return miniHeroList;
  }
}
