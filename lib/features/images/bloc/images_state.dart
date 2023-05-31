part of 'images_bloc.dart';

class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesIsLoading extends ImagesState {}

class AllImagesLoaded extends ImagesState {}

class ImagesFailure extends ImagesState {}

class ImagesLoaded extends ImagesState {
  ImagesLoaded(this.paths, this.list);
  List<String> paths;
  List<Hero> list;
}
