import 'package:plab_api/domain/enums/nasa_search_enum.dart';

abstract class NasaHistoryEvent {}

class LoadNasaHistory extends NasaHistoryEvent {
  final int? count;
  final NasaSearchEnum query;

  LoadNasaHistory({
    this.count,
    this.query = NasaSearchEnum.earth,
  });
}