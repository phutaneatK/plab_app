import 'package:equatable/equatable.dart';
import 'package:plab_api/domain/entities/nasa_entity.dart';

abstract class NasaHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NasaHistoryInitial extends NasaHistoryState {}

class NasaHistoryLoading extends NasaHistoryState {}

class NasaHistoryHasData extends NasaHistoryState {
  final List<NasaEntity> items;

  NasaHistoryHasData(this.items);

  @override
  List<Object?> get props => [items];
}

class NasaHistoryError extends NasaHistoryState {
  final String message;

  NasaHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}