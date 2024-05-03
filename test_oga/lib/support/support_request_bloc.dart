import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_oga/support/support_request_repository.dart';
import 'package:test_oga/support/support_request.dart';

abstract class SupportRequestEvent {}

class FetchRequestsEvent extends SupportRequestEvent {}

class CreateRequestEvent extends SupportRequestEvent {
  final String message;
  final List<String> images;
  final List<String> documents;

  CreateRequestEvent({
    required this.message,
    this.images = const [],
    this.documents = const [],
  });
}

abstract class SupportRequestState {}

class SupportRequestLoading extends SupportRequestState {}

class SupportRequestLoaded extends SupportRequestState {
  final List<SupportRequest> requests;

  SupportRequestLoaded(this.requests);
}

class SupportRequestError extends SupportRequestState {}

class SupportRequestBloc extends Bloc<SupportRequestEvent, SupportRequestState> {
  final SupportRequestRepository supportRequestRepository;

  SupportRequestBloc(this.supportRequestRepository) : super(SupportRequestLoading()) {
    on<FetchRequestsEvent>((event, emit) async {
      emit(SupportRequestLoading());
      try {
        final requests = await supportRequestRepository.getRequests();
        emit(SupportRequestLoaded(requests));
      } catch (e) {
        emit(SupportRequestError());
      }
    });

    on<CreateRequestEvent>((event, emit) async {
      try {
        await supportRequestRepository.createRequest(
          event.message,
          images: event.images,
          documents: event.documents,
        );
        final requests = await supportRequestRepository.getRequests();
        emit(SupportRequestLoaded(requests));
      } catch (e) {
        emit(SupportRequestError());
      }
    });
  }
}
