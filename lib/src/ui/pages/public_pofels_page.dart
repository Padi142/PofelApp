import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_event.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_state.dart';

class PublicPofelsPage extends StatefulWidget {
  PublicPofelsPage({Key? key}) : super(key: key);

  @override
  State<PublicPofelsPage> createState() => _DashboardPageState();
}

PublicPofelBloc pofelBloc = PublicPofelBloc();

class _DashboardPageState extends State<PublicPofelsPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PublicPofelBloc>(context).add(LoadPublicPofels());

    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<PublicPofelBloc, PublicPofelState>(
            builder: (context, state) {
              if (state is PublicPofelsLoaded) {
                if (state.publicPofelEnum == PublicPofelEnum.LOADED) {
                  return Expanded(
                    child: FlutterMap(
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
                        MarkerLayerOptions(
                          markers: state.markers,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              } else {
                return Container();
              }
            },
          )
        ]);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
}
