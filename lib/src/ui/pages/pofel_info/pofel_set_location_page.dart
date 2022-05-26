import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/ui/components/gradient_button.dart';

import '../../../core/bloc/pofel_bloc/pofel_bloc.dart';

class SetLocationPage extends StatefulWidget {
  final PofelModel pofel;
  SetLocationPage({Key? key, required this.pofel}) : super(key: key);

  @override
  State<SetLocationPage> createState() => _DashboardPageState();
}

PublicPofelBloc pofelBloc = PublicPofelBloc();
MapController controler = MapController();

class _DashboardPageState extends State<SetLocationPage> {
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
                        center: LatLng(49.826860, 15.479491),
                        zoom: 6.8,
                      ),
                      layers: [
                        TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c'],
                          attributionBuilder: (_) {
                            return Text("© OpenStreetMap contributors");
                          },
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
                    double lat = controler.center.latitude;
                    double lng = controler.center.longitude;
                    BlocProvider.of<PofelBloc>(context).add(UpdatePofel(
                        updatePofelEnum: UpdatePofelEnum.UPDATE_LOCATION,
                        pofelId: widget.pofel.pofelId,
                        newLocation: GeoPoint(lat, lng)));
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
