sealed class ReviewResultState {}

class ReviewNoneState extends ReviewResultState {}

class ReviewLoadingState extends ReviewResultState {}

class ReviewErrorState extends ReviewResultState {
  final String error;
  ReviewErrorState(this.error);
}

class ReviewLoadedState extends ReviewResultState {
  final String message;

  ReviewLoadedState(this.message);
}
