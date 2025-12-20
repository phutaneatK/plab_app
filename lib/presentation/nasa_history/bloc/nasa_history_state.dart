
import 'package:plab_api/domain/entities/nasa_entity.dart';

abstract class NasaHistoryState {}

class NasaHistoryInitial extends NasaHistoryState {}

class NasaHistoryLoading extends NasaHistoryState {}

class NasaHistoryHasData extends NasaHistoryState {
  final List<NasaEntity> items;

  NasaHistoryHasData(this.items);
}

class NasaHistoryError extends NasaHistoryState {
  final String message;

  NasaHistoryError(this.message);
}