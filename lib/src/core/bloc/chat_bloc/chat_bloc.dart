import 'package:bloc/bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_event.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_state.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/providers/chat_provider.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:pofel_app/src/core/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc()
      : super(const ChatsLoaded(
            chatStateEnum: ChatStateEnum.INITIAL,
            messages: [],
            errorMessage: "")) {
    on<LoadFirstChats>(_onChatsLoaded);
    on<SendMessage>(_onSendMessage);
  }
  final ChatProvider _chatProvider = ChatProvider();
  final NotificationProvider _notificationProvider = NotificationProvider();
  final UserProvider _userProvider = UserProvider();
  _onChatsLoaded(LoadFirstChats event, Emitter<ChatState> emit) async {
    List<MessageModel> messages =
        await _chatProvider.fetchFirstMessages(event.pofelId);

    emit((state as ChatsLoaded).copyWith(
        messages: messages,
        chatStateEnum: ChatStateEnum.LOADED,
        errorMessage: ""));
  }

  _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString("uid");
      if (uid == null) {
        emit((state as ChatsLoaded).copyWith(
            errorMessage: 'Nepodařilo se zjistit aktuálního uživatele.'));
        return;
      }

      UserModel user = await _userProvider.fetchUserData(uid);
      MessageModel message = MessageModel(
          message: event.message,
          sentOn: DateTime.now(),
          sentByUid: uid,
          sentByProfilePic: user.photo!,
          sentByName: user.name!);
      await _chatProvider.sendMessage(message, event.pofelId);
      await _notificationProvider.notifyChatMessage(
        pofelId: event.pofelId,
        message: message,
      );
      final messages = await _chatProvider.fetchFirstMessages(event.pofelId);
      emit((state as ChatsLoaded)
          .copyWith(messages: messages, errorMessage: ""));
    } catch (e) {
      emit((state as ChatsLoaded).copyWith(errorMessage: e.toString()));
    }
  }
}
