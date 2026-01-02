import 'package:equatable/equatable.dart';

abstract class Pm25Event  {}

class loadPm25History extends Pm25Event {
  final String search;
  loadPm25History({required this.search});
}