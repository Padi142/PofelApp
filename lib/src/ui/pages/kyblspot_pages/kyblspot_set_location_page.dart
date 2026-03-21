import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_bloc.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/core/models/geo_point.dart';
import 'package:pofel_app/src/ui/components/gradient_button.dart';

class KyblspotSetLocationPage extends StatefulWidget {
  KyblspotSetLocationPage({Key? key}) : super(key: key);

  @override
  State<KyblspotSetLocationPage> createState() => _DashboardPageState();
}

PublicPofelBloc pofelBloc = PublicPofelBloc();
MapController controler = MapController();

class _DashboardPageState extends State<KyblspotSetLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: controler,
                      options: MapOptions(
                        initialCenter: LatLng(49.826860, 15.479491),
                        initialZoom: 6.8,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.padisoft.pofelApp',
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset("assets/images/kruh.png"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: GradientButton(
                  buttonText: 'Nastavit',
                  onpressed: () {
                    double lat = controler.camera.center.latitude;
                    double lng = controler.camera.center.longitude;
                    BlocProvider.of<KyblCreationBloc>(context)
                        .add(AddKyblspotCoordnates(
                      location: GeoPoint(lat, lng),
                    ));
                    Navigator.pop(context);
                  },
                  width: double.infinity,
                ),
              )
            ]),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
}
