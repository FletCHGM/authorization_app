import 'package:authorization_app/features/repos/repos_view.dart';
part 'images_event.dart';
part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(ImagesInitial()) {
    on<FirstTryToLoadImages>((event, emit) async {
      emit(ImagesIsLoading());
      try {
        ListResult? items = await imagesRef.listAll();
        List<String> paths =
            await FirebaseImagePicker().getFirebaseImagesPaths(items);
        List<String> URLs =
            await FirebaseImagePicker().getFirebaseImagesURLs(paths);
        List<Hero> list = ImageHero().imageHero(event.context, URLs);
        var i = URLs.length;
        while (i > 0) {
          paths.remove(paths.first);
          i--;
        }
        emit(ImagesLoaded(paths, list));
      } catch (e) {
        emit(ImagesFailure());
      }
    });

    on<TryToLoadImages>((event, emit) async {
      emit(ImagesIsLoading());
      try {
        List<String> paths = event.paths;
        List<Hero> list = [];
        List<String> URLs =
            await FirebaseImagePicker().getFirebaseImagesURLs(event.paths);
        var i = URLs.length;
        while (i > 0) {
          paths.remove(paths.first);
          i--;
        }
        List<Hero> pickedImages = ImageHero().imageHero(event.context, URLs);
        if (!pickedImages.isEmpty) {
          for (var i in pickedImages) {
            list.add(i);
          }
          emit(ImagesLoaded(paths, list));
        } else {
          emit(AllImagesLoaded());
        }
      } catch (e) {
        emit(ImagesFailure());
      }
    });
  }
}
