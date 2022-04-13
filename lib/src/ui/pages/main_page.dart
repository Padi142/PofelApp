import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/ui/components/top_bar.dart';
import 'package:pofel_app/src/ui/pages/dashboard_page.dart';
import 'package:pofel_app/src/ui/pages/log_in_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_detail_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_list_page.dart';
import 'package:pofel_app/src/ui/pages/public_pofels_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/notification_page.dart';
import 'package:pofel_app/src/ui/pages/user_pages/user_detail_page.dart';
import 'package:pofel_app/src/ui/pages/user_search_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).add(const DashboardEvent());
    int _selectedIndex = 0;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: BlocBuilder<NavigationBloc, NavigationState>(
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
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: GNav(
              rippleColor: const Color(0xFFFFC8DD),
              hoverColor: Colors.grey[100]!,
              gap: 4,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: primaryColor,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home_max_outlined,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.list_rounded,
                  text: 'Moje pofely',
                ),
                GButton(
                  icon: Icons.map_rounded,
                  text: "Mapa",
                ),
                GButton(
                  icon: Icons.search_outlined,
                  text: "Hledat",
                ),
                GButton(
                  icon: Icons.verified_user,
                  text: 'Profil',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                switch (index) {
                  case 0:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(const DashboardEvent());
                    break;
                  case 1:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(const LoadMyPofelsEvent());
                    break;
                  case 2:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(const LoadPublicPofelPage());
                    break;
                  case 3:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(const LoadSearchProfiles());
                    break;
                  case 4:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(const LoadCurrentUserPage());
                    break;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
