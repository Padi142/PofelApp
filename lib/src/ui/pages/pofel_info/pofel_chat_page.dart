import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_event.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_state.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/chat_bubbles.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';

class PofelChatPage extends StatefulWidget {
  const PofelChatPage({
    super.key,
    required this.pofel,
    required this.currentUserUid,
  });

  final PofelModel pofel;
  final String currentUserUid;

  @override
  State<PofelChatPage> createState() => _PofelChatPageState();
}

class _PofelChatPageState extends State<PofelChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context
          .read<ChatBloc>()
          .add(LoadFirstChats(pofelId: widget.pofel.pofelId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listenWhen: (previous, current) =>
          current is ChatsLoaded &&
          current.errorMessage.isNotEmpty &&
          (previous is! ChatsLoaded ||
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        final chatState = state as ChatsLoaded;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBarError(context, chatState.errorMessage),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is! ChatsLoaded ||
                      state.chatStateEnum == ChatStateEnum.INITIAL) {
                    return const _ChatLoadingCard();
                  }

                  if (state.messages.isEmpty) {
                    return const _ChatEmptyCard();
                  }

                  final messages = state.messages.reversed.toList();
                  return PofelSurfaceCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: ListView.separated(
                      reverse: true,
                      itemCount: messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        if (message.sentByUid == widget.currentUserUid) {
                          return myChat(context, message);
                        }
                        return otherChat(context, message);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            PofelSurfaceCard(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Napiš zprávu pro pofel...',
                        hintStyle: TextStyle(
                          color: PofelPalette.text.withValues(alpha: 0.45),
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: PofelPalette.buttonGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      constraints: const BoxConstraints.tightFor(
                        width: 58,
                        height: 58,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      return;
    }

    context.read<ChatBloc>().add(
          SendMessage(
            message: message,
            pofelId: widget.pofel.pofelId,
          ),
        );
    _messageController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class _ChatLoadingCard extends StatelessWidget {
  const _ChatLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const PofelSurfaceCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Načítám zprávy...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatEmptyCard extends StatelessWidget {
  const _ChatEmptyCard();

  @override
  Widget build(BuildContext context) {
    return PofelSurfaceCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              gradient: PofelPalette.panelGradient,
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Chat je zatím prázdný',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: PofelPalette.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pošli první zprávu a rozjeď domluvu pro celý pofel.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PofelPalette.text.withValues(alpha: 0.7),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
