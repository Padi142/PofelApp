import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_event.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_state.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/kyblspot_pages/kybl_add_page.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/snack_bar_error.dart';

class KyblspotsPage extends StatefulWidget {
  KyblspotsPage({Key? key}) : super(key: key);

  @override
  State<KyblspotsPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<KyblspotsPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<KyblspotBloc>(context).add(const LoadKyblspots());
    MapController controller = MapController();

    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<KyblspotBloc, KyblspotState>(
            builder: (context, state) {
              if (state is KyblspotLoadedState) {
                if (state.kyblspotEnum == KyblspotEnum.LOADED ||
                    state.kyblspotEnum == KyblspotEnum.REVIEWS_LOADED) {
                  return Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: controller,
                          options: MapOptions(
                            interactiveFlags: InteractiveFlag.pinchZoom |
                                InteractiveFlag.drag,
                            plugins: [
                              MarkerClusterPlugin(),
                            ],
                            center: LatLng(49.826860, 15.479491),
                            zoom: 6.8,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                              attributionBuilder: (_) {
                                return const Text(
                                    "© OpenStreetMap contributors");
                              },
                            ),
                            MarkerClusterLayerOptions(
                              maxClusterRadius: 120,
                              size: const Size(40, 40),
                              fitBoundsOptions: const FitBoundsOptions(
                                padding: EdgeInsets.all(50),
                              ),
                              markers: state.markers,
                              polygonOptions: const PolygonOptions(
                                  borderColor: Colors.blueAccent,
                                  color: Colors.black12,
                                  borderStrokeWidth: 3),
                              builder: (context, markers) {
                                var rng = Random();
                                return FloatingActionButton(
                                  heroTag: rng.nextInt(10000),
                                  child: Text(markers.length.toString()),
                                  onPressed: null,
                                );
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 30, right: 15),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddKyblPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary: Colors.purple, // <-- Button color
                                ),
                                child: const Icon(Icons.add)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 105, right: 15),
                            child: ElevatedButton(
                                onPressed: () async {
                                  bool serviceEnabled;
                                  LocationPermission permission;

                                  serviceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBarError(
                                            context, 'Lokace je zakázána :/'));
                                  }

                                  permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBarError(context,
                                              'Lokace je zakázána :/'));
                                    }
                                  }

                                  if (permission ==
                                      LocationPermission.deniedForever) {
                                    // Permissions are denied forever, handle appropriately.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBarError(
                                            context, 'Lokace je zakázána :/'));
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBarAlert(
                                          context, 'Získávám koordináty'));

                                  await Geolocator.getCurrentPosition();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  final location =
                                      await Geolocator.getCurrentPosition();

                                  LatLng position = LatLng(
                                      location.latitude, location.longitude);
                                  controller.move(position, 15.0);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  primary: Colors.purple, // <-- Button color
                                ),
                                child: const Icon(Icons.my_location)),
                          ),
                        )
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
