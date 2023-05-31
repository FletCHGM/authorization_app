part of 'images_bloc.dart';

sealed class ImagesState {}

class ImagesInitial implements ImagesState {}

class ImagesIsLoading implements ImagesState {}

class AllImagesLoaded implements ImagesState {}

class ImagesFailure implements ImagesState {}

class ImagesLoaded implements ImagesState {
  ImagesLoaded(this.paths, this.list);
  List<String> paths;
  List<Hero> list;
}
