import 'package:equatable/equatable.dart';
import 'package:plab_api/domain/entities/chat_message_entity.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatConnected extends ChatState {
  final List<ChatMessageEntity> messages;
  final bool isProcessing; // เพิ่ม flag สำหรับการประมวลผล

  ChatConnected(this.messages, {this.isProcessing = false});

  @override
  List<Object?> get props => [messages, isProcessing];
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatDisconnected extends ChatState {}
