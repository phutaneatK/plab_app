import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/enums/nasa_search_enum.dart';
import 'nasa_search_query_state.dart';

/// Cubit สำหรับจัดการ state ของ query ที่เลือก
/// ใช้แชร์ state ระหว่างหน้า List และหน้า Settings
class NasaSearchQueryCubit extends Cubit<NasaSearchQueryState> {
  NasaSearchQueryCubit() : super(const NasaSearchQueryState());

  /// เปลี่ยนค่า query ที่เลือก
  void changeQuery(NasaSearchEnum query) {
    emit(state.copyWith(selectedQuery: query));
  }

  /// Reset กลับไปค่า default (earth)
  void resetToDefault() {
    emit(const NasaSearchQueryState(selectedQuery: NasaSearchEnum.earth));
  }
}
