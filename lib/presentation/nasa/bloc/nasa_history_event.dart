import 'package:plab_api/domain/enums/nasa_search_enum.dart';

abstract class NasaHistoryEvent {}

class LoadNasaHistory extends NasaHistoryEvent {
  final bool reloadFail;
  final int? count;
  final NasaSearchEnum query;

  LoadNasaHistory({
    this.reloadFail = true,
    this.count,
    this.query = NasaSearchEnum.earth,
  });
}