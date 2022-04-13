import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_event.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_state.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/message_model.dart';
import 'package:pofel_app/src/core/providers/chat_provider.dart';
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
  ChatProvider _chatProvider = ChatProvider();
  UserProvider _userProvider = UserProvider();
  _onChatsLoaded(LoadFirstChats event, Emitter<ChatState> emit) async {
    List<MessageModel> messages =
        await _chatProvider.fetchFirstMessages(event.pofelId);

    emit((state as ChatsLoaded)
        .copyWith(messages: messages, chatStateEnum: ChatStateEnum.LOADED));

    final Stream<QuerySnapshot> _chatStream = FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(event.pofelId)
        .collection("chat")
        .orderBy("sentOn")
        .limit(20)
        .snapshots();
    _chatStream.map((event) => event.docs.forEach((message) {
          messages.add(MessageModel.fromMap(message));
        }));
    emit((state as ChatsLoaded).copyWith(messages: messages));
  }

  _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString("uid");

      UserModel user = await _userProvider.fetchUserData(uid!);
      MessageModel message = MessageModel(
          message: event.message,
          sentOn: DateTime.now(),
          sentByUid: uid,
          sentByProfilePic: user.photo!,
          sentByName: user.name!);
      _chatProvider.sendMessage(message, event.pofelId);
    } catch (e) {
      emit((state as ChatsLoaded).copyWith(errorMessage: e.toString()));
    }
  }
}
