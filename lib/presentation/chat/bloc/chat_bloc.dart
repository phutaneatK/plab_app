import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plab_api/domain/entities/chat_message_entity.dart';
import 'package:plab_api/domain/usecases/get_chat_history.dart';
import 'package:plab_api/domain/usecases/get_chat_messages_stream.dart';
import 'package:plab_api/domain/usecases/send_chat_message.dart';
import 'package:plab_api/domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatMessagesStream getChatMessagesStream;
  final SendChatMessage sendChatMessage;
  final GetChatHistory getChatHistory;
  final ChatRepository chatRepository;

  StreamSubscription<ChatMessageEntity>? _messageSubscription;
  final List<ChatMessageEntity> _messages = [];

  ChatBloc({
    required this.getChatMessagesStream,
    required this.sendChatMessage,
    required this.getChatHistory,
    required this.chatRepository,
  }) : super(ChatInitial()) {
    on<ConnectChat>(_onConnectChat);
    on<DisconnectChat>(_onDisconnectChat);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  Future<void> _onConnectChat(ConnectChat event, Emitter<ChatState> emit) async {
    try {
      emit(ChatConnecting());

      // เชื่อมต่อ
      await chatRepository.connect();

      // โหลดประวัติ
      final history = await getChatHistory();
      _messages.clear();
      _messages.addAll(history);

      // ฟัง stream
      _messageSubscription = getChatMessagesStream().listen(
        (message) {
          add(ReceiveMessage(message));
        },
      );

      emit(ChatConnected(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onDisconnectChat(DisconnectChat event, Emitter<ChatState> emit) async {
    await _messageSubscription?.cancel();
    await chatRepository.disconnect();
    _messages.clear();
    emit(ChatDisconnected());
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      await sendChatMessage(event.message);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    _messages.add(event.message);
    emit(ChatConnected(List.from(_messages)));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
