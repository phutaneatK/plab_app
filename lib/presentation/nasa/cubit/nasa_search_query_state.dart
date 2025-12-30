import 'package:plab_api/domain/enums/nasa_search_enum.dart';

/// State สำหรับเก็บค่า query ที่เลือก
class NasaSearchQueryState {
  final NasaSearchEnum selectedQuery;

  const NasaSearchQueryState({
    this.selectedQuery = NasaSearchEnum.earth,
  });

  NasaSearchQueryState copyWith({
    NasaSearchEnum? selectedQuery,
  }) {
    return NasaSearchQueryState(
      selectedQuery: selectedQuery ?? this.selectedQuery,
    );
  }
}
