import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_event.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_event.dart';
import 'package:pofel_app/src/core/models/notification_model.dart';
import 'package:pofel_app/src/core/providers/notification_provider.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.currentUid});

  final String currentUid;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationProvider _notificationProvider = NotificationProvider();
  NotificationType? _selectedType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _markAllAsRead());
  }

  Future<void> _markAllAsRead() async {
    await _notificationProvider.markAllAsRead(widget.currentUid);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upozornění',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: PofelPalette.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Důležité věci z pofelů, chatu i sociálních interakcí.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PofelPalette.text.withValues(alpha: 0.72),
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Všechno', null),
              _buildFilterChip('Pozvánky', NotificationType.invite),
              _buildFilterChip('Chat', NotificationType.message),
              _buildFilterChip('Questy', NotificationType.questAssigned),
              _buildFilterChip('Oznámení', NotificationType.announcement),
              _buildFilterChip('Follows', NotificationType.follow),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<NotificationModel>>(
              future:
                  _notificationProvider.fetchNotifications(widget.currentUid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var notifications = snapshot.data!;
                if (_selectedType != null) {
                  notifications = notifications.where((notification) {
                    if (_selectedType == NotificationType.questAssigned) {
                      return notification.type ==
                              NotificationType.questAssigned ||
                          notification.type == NotificationType.questCompleted;
                    }
                    return notification.type == _selectedType;
                  }).toList();
                }

                if (notifications.isEmpty) {
                  return Center(
                    child: Text(
                      'Zatím tu nic není.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _NotificationCard(notification: notifications[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, NotificationType? type) {
    final selected = _selectedType == type;
    return FilterChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) {
        setState(() {
          _selectedType = type;
        });
      },
      selectedColor: PofelPalette.softLilac,
      checkmarkColor: PofelPalette.primaryDark,
      labelStyle: TextStyle(
        color: selected ? PofelPalette.primaryDark : PofelPalette.text,
        fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final meta = _notificationMeta(notification.type);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: notification.pofelId.isEmpty
          ? null
          : () {
              context
                  .read<NavigationBloc>()
                  .add(PofelDetailPageEvent(pofelId: notification.pofelId));
            },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: meta.color.withValues(alpha: 0.18)),
          boxShadow: const [
            BoxShadow(
              color: PofelPalette.shadow,
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: meta.color.withValues(alpha: 0.12),
                    foregroundImage: notification.sentByProfilePic.isEmpty
                        ? null
                        : NetworkImage(notification.sentByProfilePic),
                    child: notification.sentByProfilePic.isEmpty
                        ? Icon(meta.icon, color: meta.color)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meta.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: PofelPalette.text,
                                  ),
                        ),
                        Text(
                          DateFormat('dd.MM.  HH:mm')
                              .format(notification.sentOn),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color:
                                    PofelPalette.text.withValues(alpha: 0.56),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.shown)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: meta.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                notification.message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: PofelPalette.text,
                      height: 1.35,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildActions(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (notification.type) {
      case NotificationType.follow:
        return [
          FilledButton.icon(
            onPressed: () {
              context
                  .read<SocialBloc>()
                  .add(Follow(userId: notification.userId));
            },
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Sledovat zpátky'),
          ),
        ];
      case NotificationType.invite:
        return [
          FilledButton.icon(
            onPressed: () {
              context
                  .read<PofelBloc>()
                  .add(JoinPofel(joinId: notification.pofelId));
              context.read<LoadpofelsBloc>().add(const LoadMyPofels());
            },
            icon: const Icon(Icons.groups_rounded),
            label: const Text('Připojit se'),
          ),
        ];
      case NotificationType.message:
      case NotificationType.announcement:
      case NotificationType.questAssigned:
      case NotificationType.questCompleted:
        if (notification.pofelId.isEmpty) {
          return const [];
        }
        return [
          OutlinedButton.icon(
            onPressed: () {
              context
                  .read<NavigationBloc>()
                  .add(PofelDetailPageEvent(pofelId: notification.pofelId));
            },
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Otevřít pofel'),
          ),
        ];
      case NotificationType.none:
        return const [];
    }
  }

  _NotificationMeta _notificationMeta(NotificationType type) {
    switch (type) {
      case NotificationType.invite:
        return const _NotificationMeta(
          title: 'Pozvánka',
          icon: Icons.mail_rounded,
          color: Color(0xFF7B1BC5),
        );
      case NotificationType.follow:
        return const _NotificationMeta(
          title: 'Follow',
          icon: Icons.favorite_rounded,
          color: Color(0xFFE54B7A),
        );
      case NotificationType.message:
        return const _NotificationMeta(
          title: 'Chat',
          icon: Icons.chat_bubble_rounded,
          color: Color(0xFF2F6FD6),
        );
      case NotificationType.announcement:
        return const _NotificationMeta(
          title: 'Oznámení',
          icon: Icons.campaign_rounded,
          color: Color(0xFFF28F16),
        );
      case NotificationType.questAssigned:
        return const _NotificationMeta(
          title: 'Nový quest',
          icon: Icons.assignment_turned_in_rounded,
          color: Color(0xFF0E9F6E),
        );
      case NotificationType.questCompleted:
        return const _NotificationMeta(
          title: 'Quest hotový',
          icon: Icons.task_alt_rounded,
          color: Color(0xFF0E9F6E),
        );
      case NotificationType.none:
        return const _NotificationMeta(
          title: 'Notifikace',
          icon: Icons.notifications_rounded,
          color: Color(0xFF5D6270),
        );
    }
  }
}

class _NotificationMeta {
  const _NotificationMeta({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}
