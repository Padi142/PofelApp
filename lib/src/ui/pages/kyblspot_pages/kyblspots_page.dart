import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_event.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_state.dart';
import 'package:pofel_app/src/ui/components/toast_alert.dart';
import 'package:pofel_app/src/ui/pages/kyblspot_pages/kybl_add_page.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/snack_bar_error.dart';

class KyblspotsPage extends StatefulWidget {
  const KyblspotsPage({super.key});

  @override
  State<KyblspotsPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<KyblspotsPage> {
  final MapController _controller = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<KyblspotBloc>().add(const LoadKyblspots());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<KyblspotBloc, KyblspotState>(
            builder: (context, state) {
              if (state is KyblspotLoadedState) {
                if (state.kyblspotEnum == KyblspotEnum.loaded ||
                    state.kyblspotEnum == KyblspotEnum.reviewsLoaded) {
                  return Expanded(
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _controller,
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
                            MarkerLayer(markers: state.markers),
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
                                  backgroundColor:
                                      Colors.purple, // <-- Button color
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
                                  final serviceEnabled = await Geolocator
                                      .isLocationServiceEnabled();
                                  if (!serviceEnabled) {
                                    if (!mounted) {
                                      return;
                                    }
                                    _showLocationError();
                                    return;
                                  }

                                  var permission =
                                      await Geolocator.checkPermission();
                                  if (permission == LocationPermission.denied) {
                                    permission =
                                        await Geolocator.requestPermission();
                                    if (permission ==
                                        LocationPermission.denied) {
                                      if (!mounted) {
                                        return;
                                      }
                                      _showLocationError();
                                      return;
                                    }
                                  }

                                  if (permission ==
                                      LocationPermission.deniedForever) {
                                    if (!mounted) {
                                      return;
                                    }
                                    _showLocationError();
                                    return;
                                  }
                                  if (!mounted) {
                                    return;
                                  }
                                  _showLocationLoading();

                                  await Geolocator.getCurrentPosition();
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  final location =
                                      await Geolocator.getCurrentPosition();
                                  if (!mounted) {
                                    return;
                                  }

                                  LatLng position = LatLng(
                                      location.latitude, location.longitude);
                                  _controller.move(position, 15.0);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor:
                                      Colors.purple, // <-- Button color
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

  void _showLocationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarError(context, 'Lokace je zakázána :/'),
    );
  }

  void _showLocationLoading() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarAlert(context, 'Získávám koordináty'),
    );
  }
}
