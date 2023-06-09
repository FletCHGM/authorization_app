import '../repos_view.dart';

class ImageHero {
  List<Hero> imageHero(BuildContext context, List<String> URLs) {
    List<Hero> miniHeroList = [];
    List<Hero> heroList = [];
    String image;
    if (URLs.isEmpty) {
      List<Hero> emptyList = [];
      return emptyList;
    }
    for (image in URLs) {
      Hero heroFullImage = Hero(
          tag: image,
          child: Scaffold(
            appBar: AppBar(),
            body: Center(child: Image.network(image)),
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
