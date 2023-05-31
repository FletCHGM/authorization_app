part of 'images_bloc.dart';

class ImagesEvent {}

class FirstTryToLoadImages extends ImagesEvent {
  FirstTryToLoadImages(this.context);
  BuildContext context;
}

class TryToLoadImages extends ImagesEvent {
  TryToLoadImages(this.context, this.paths);
  BuildContext context;
  List<String> paths;
}
