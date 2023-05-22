import '../Home/widgets/widgets_view.dart';

class ImageHero {
  fullScreenImage(BuildContext context, Image image) {
    Scaffold imageScreen = Scaffold(
      body: image,
    );
  }

  imageHero(BuildContext context) async {
    List images = await FirebaseImagePicker().getFirebaseImages();
    List<Hero> boxList = [];
    List<Hero> heroList = [];
    String image;
    for (image in images) {
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
      boxList.add(heroSmallImage);
    }
    return boxList;
  }
}
