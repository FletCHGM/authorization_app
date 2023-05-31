part of 'images_bloc.dart';

sealed class ImagesEvent {}

class FirstTryToLoadImages implements ImagesEvent {
  FirstTryToLoadImages(this.context);
  BuildContext context;
}

class TryToLoadImages implements ImagesEvent {
  TryToLoadImages(this.context, this.paths);
  BuildContext context;
  List<String> paths;
}
