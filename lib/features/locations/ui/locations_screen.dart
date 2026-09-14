import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../clubs/data/clubs_api.dart';
import '../../clubs/data/models.dart';

const _markerFallback = 'https://cdn-icons-png.flaticon.com/512/5860/5860579.png';

final availableGameCentersProvider = FutureProvider<List<GameCenter>>((ref) => ref.watch(clubsApiProvider).gameCenters(isAvailable: true));

class LocationsScreen extends ConsumerStatefulWidget {
  const LocationsScreen({super.key});

  @override
  ConsumerState<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends ConsumerState<LocationsScreen> {
  final _controller = MapController();
  double _zoom = 13;
  GameCenter? _popup;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LatLng? _point(GameCenter c) {
    final lat = c.latitude;
    final lng = c.longitude;
    if (lat == null || lng == null) return null;
    return LatLng(lat / 1000000, lng / 1000000);
  }

  void _zoomBy(double delta) {
    final camera = _controller.camera;
    _controller.move(camera.center, (camera.zoom + delta).clamp(1, 18));
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(availableGameCentersProvider).value ?? const <GameCenter>[];
    final size = (_zoom * 5).clamp(20.0, 200.0);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCenter: const LatLng(43.238949, 76.889709),
            initialZoom: 13,
            maxZoom: 18,
            backgroundColor: AceColors.bg,
            onTap: (_, _) => setState(() => _popup = null),
            onPositionChanged: (camera, _) {
              if ((camera.zoom - _zoom).abs() > 0.01) setState(() => _zoom = camera.zoom);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'gg.acegaming.acemobile',
            ),
            MarkerLayer(
              markers: [
                for (final c in clubs)
                  if (_point(c) case final p?)
                    Marker(
                      point: p,
                      width: size,
                      height: size,
                      child: GestureDetector(
                        onTap: () => setState(() => _popup = _popup?.id == c.id ? null : c),
                        child: CachedNetworkImage(
                          imageUrl: c.logo?.isNotEmpty == true ? c.logo! : _markerFallback,
                          fit: BoxFit.contain,
                          errorWidget: (_, _, _) => const AceIcon('location-pin-alt-1', color: AceColors.accent),
                        ),
                      ),
                    ),
              ],
            ),
            if (_popup case final c?)
              if (_point(c) case final p?)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: p,
                      width: 220,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AceColors.card,
                          borderRadius: BorderRadius.circular(AceRadius.pill),
                          boxShadow: AceShadows.card,
                        ),
                        child: Text(
                          c.name?.isNotEmpty == true ? c.name! : (c.address ?? ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AceText.style(size: 13, weight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
        Positioned(
          right: 10,
          bottom: bottom + 10,
          child: Column(
            spacing: 8,
            children: [
              AceCircleButton(icon: 'plus', onTap: () => _zoomBy(1)),
              AceCircleButton(icon: 'minus', onTap: () => _zoomBy(-1)),
            ],
          ),
        ),
      ],
    );
  }
}
