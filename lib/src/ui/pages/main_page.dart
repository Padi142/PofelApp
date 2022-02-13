import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/ui/components/top_bar.dart';
import 'package:pofel_app/src/ui/pages/dashboard_page.dart';
import 'package:pofel_app/src/ui/pages/log_in_page.dart';
import 'package:pofel_app/src/ui/pages/pofel_detail_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<NavigationBloc>(context).add(DashboardEvent());
    int _selectedIndex = 0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Flexible(child: TopAppBar("Pofel app")),
            Expanded(
                flex: 5,
                child: BlocBuilder<NavigationBloc, NavigationState>(
                  builder: (context, state) {
                    if (state is ShowDashboardState) {
                      return DashboardPage();
                    }
                    if (state is ShowPofelDetailState) {
                      return PofelDetailPage(
                        pofelId: state.pofelId,
                      );
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Color(0xFFFFC8DD),
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
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
                  icon: Icons.search,
                  text: 'Search',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                switch (index) {
                  case 0:
                    BlocProvider.of<NavigationBloc>(context)
                        .add(DashboardEvent());
                    break;
                  case 1:
                    // BlocProvider.of<NavigationBloc>(context)
                    //    .add(LogInPageEvent());
                    break;
                  case 2:
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
