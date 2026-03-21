import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NavigationBloc>().add(const DashboardEvent());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pofel app"),
        backgroundColor: const Color(0xFF8F3BB7),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<NavigationBloc>(context)
                    .add(const LoadNotificationsPage());
              },
              child: const Icon(Icons.notifications),
            ),
          )
        ],
      ),
      body: SafeArea(
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              backgroundColor: Colors.white,
              indicatorColor: primaryColor,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.read<NavigationBloc>().add(const DashboardEvent());
                    break;
                  case 1:
                    context.read<NavigationBloc>().add(const LoadMyPofelsEvent());
                    break;
                  case 2:
                    context.read<NavigationBloc>().add(const LoadKyblspotsPgae());
                    break;
                  case 3:
                    context.read<NavigationBloc>().add(const LoadSearchProfiles());
                    break;
                  case 4:
                    context.read<NavigationBloc>().add(const LoadCurrentUserPage());
                    break;
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_max_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_rounded),
                  label: 'Moje pofely',
                ),
                NavigationDestination(
                  icon: Icon(Icons.map_rounded),
                  label: 'Mapa',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined),
                  label: 'Hledat',
                ),
                NavigationDestination(
                  icon: Icon(Icons.verified_user),
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
