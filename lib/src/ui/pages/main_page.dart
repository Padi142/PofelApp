import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:async';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/notifications/push_notification_service.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/pages/dashboard_page.dart';
import 'package:pofel_app/src/ui/pages/kyblspot_pages/kyblspots_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_detail_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_list_page.dart';
import 'package:pofel_app/src/ui/pages/public_pofels_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/notification_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_detail_page.dart';
import 'package:pofel_app/src/ui/pages/user_search_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PushNotificationService _pushNotificationService =
      PushNotificationService();
  StreamSubscription<RemoteMessage>? _foregroundMessagesSubscription;
  String? _lastForegroundMessageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NavigationBloc>().add(const DashboardEvent());
    });
    _initializePushNotifications();
  }

  void _syncSelectedIndex(NavigationState state) {
    final selectedIndex = switch (state) {
      ShowDashboardState() => 0,
      ShowMyPofelsState() => 1,
      ShowKyblspotsPage() => 2,
      ShowSearchProfilesState() => 3,
      ShowUserDetailState() => 4,
      _ => _selectedIndex,
    };

    if (selectedIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = selectedIndex;
      });
    }
  }

  Future<void> _initializePushNotifications() async {
    await _pushNotificationService.initialize();
    _foregroundMessagesSubscription = _pushNotificationService
        .foregroundMessages
        .listen(_onForegroundMessage);
  }

  void _onForegroundMessage(RemoteMessage message) {
    if (!mounted) {
      return;
    }

    final messageId = message.messageId ?? message.sentTime?.toIso8601String();
    if (messageId != null && messageId == _lastForegroundMessageId) {
      return;
    }
    _lastForegroundMessageId = messageId;

    final title = message.notification?.title ?? 'Nová notifikace';
    final body = message.notification?.body ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(body.isEmpty ? title : '$title\n$body'),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PofelScreenBackground(
        child: SafeArea(
          child: Column(
            children: [
              PofelTopBar(
                onNotificationTap: () {
                  BlocProvider.of<NavigationBloc>(context)
                      .add(const LoadNotificationsPage());
                },
              ),
              Expanded(
                child: BlocConsumer<NavigationBloc, NavigationState>(
                  listener: (context, state) => _syncSelectedIndex(state),
                  builder: (context, state) {
                    if (state is ShowDashboardState) {
                      return DashboardPage();
                    } else if (state is ShowPofelDetailState) {
                      return PofelDetailPage(
                        pofelId: state.pofelId,
                      );
                    } else if (state is ShowMyPofelsState) {
                      return PofelListPage();
                    } else if (state is ShowSearchProfilesState) {
                      return UserSearchPage();
                    } else if (state is ShowNotificationPageState) {
                      return NotificationsPage(
                        currentUid: state.uid,
                      );
                    } else if (state is ShowUserDetailState) {
                      return const UserDetailPage();
                    } else if (state is ShowPublicPofelsState) {
                      return PublicPofelsPage();
                    } else if (state is ShowKyblspotsPage) {
                      return KyblspotsPage();
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.white,
                indicatorColor: primaryColor,
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final selected = states.contains(WidgetState.selected);
                  return TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: Colors.black,
                  );
                }),
              ),
              child: NavigationBar(
                height: 74,
                selectedIndex: _selectedIndex,
                backgroundColor: Colors.white,
                indicatorColor: primaryColor,
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                      context
                          .read<NavigationBloc>()
                          .add(const DashboardEvent());
                      break;
                    case 1:
                      context
                          .read<NavigationBloc>()
                          .add(const LoadMyPofelsEvent());
                      break;
                    case 2:
                      context
                          .read<NavigationBloc>()
                          .add(const LoadKyblspotsPgae());
                      break;
                    case 3:
                      context
                          .read<NavigationBloc>()
                          .add(const LoadSearchProfiles());
                      break;
                    case 4:
                      context
                          .read<NavigationBloc>()
                          .add(const LoadCurrentUserPage());
                      break;
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_max_outlined),
                    selectedIcon: Icon(Icons.home_rounded),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.list_rounded),
                    selectedIcon: Icon(Icons.list_alt_rounded),
                    label: 'Seznam',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.map_outlined),
                    selectedIcon: Icon(Icons.map_rounded),
                    label: 'Mapa',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.search_outlined),
                    selectedIcon: Icon(Icons.search),
                    label: 'Hledat',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.account_circle_outlined),
                    selectedIcon: Icon(Icons.account_circle_rounded),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foregroundMessagesSubscription?.cancel();
    _pushNotificationService.dispose();
    super.dispose();
  }
}
