import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sprintmap/theme/app_theme.dart';

class LibrariesView extends StatefulWidget {
  const LibrariesView({Key? key}) : super(key: key);

  @override
  State<LibrariesView> createState() => _LibrariesViewState();
}

class _LibrariesViewState extends State<LibrariesView> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _libraries = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Konum izinlerini kontrol et
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Konum izni reddedildi');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Konum izinleri kalıcı olarak reddedildi, ayarlardan etkinleştirin');
      }

      // Mevcut konumu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Yakındaki kütüphaneleri ara
      await _searchNearbyLibraries();
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyLibraries() async {
    if (_currentPosition == null) return;

    try {
      // OpenStreetMap Overpass API kullanarak yakındaki kütüphaneleri ara
      final radius = 5000; // 5 km yarıçap
      final query = '''
        [out:json];
        (
          node["amenity"="library"]
            (around:$radius,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["building"="library"]
            (around:$radius,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out body;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: query,
      );

      if (response.statusCode == 200) {
        // UTF-8 kodlaması kullanarak yanıtı işle
        final jsonString = utf8.decode(response.bodyBytes);
        final data = jsonDecode(jsonString);
        final elements = data['elements'] as List;

        setState(() {
          _libraries = elements
              .map((e) => {
                    'id': e['id'],
                    'name': e['tags']['name'] ?? 'İsimsiz Kütüphane',
                    'position': LatLng(e['lat'], e['lon']),
                    'address': e['tags']['addr:street'] ??
                        e['tags']['addr:full'] ??
                        '',
                    'operator': e['tags']['operator'] ?? '',
                    'opening_hours': e['tags']['opening_hours'] ?? '',
                  })
              .toList();
        });
      } else {
        throw Exception('Kütüphaneler yüklenemedi: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Kütüphaneler aranırken hata oluştu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : _currentPosition == null
                  ? _buildLocationNotFoundView()
                  : _buildMapView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.accentColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Bir hata oluştu',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationNotFoundView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Konum bulunamadı',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Column(
      children: [
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition!,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.sprintmap',
              ),
              MarkerLayer(
                markers: [
                  // Kullanıcının konumu
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: _currentPosition!,
                    child: Icon(
                      Icons.location_on,
                      color: AppTheme.secondaryColor,
                      size: 40.0,
                    ),
                  ),
                  // Kütüphanelerin konumları
                  ..._libraries
                      .map((library) => Marker(
                            width: 40.0,
                            height: 40.0,
                            point: library['position'],
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.bookOpen,
                                color: AppTheme.accentColor,
                              ),
                              onPressed: () {
                                _showLibraryDetails(library);
                              },
                            ),
                          ))
                      .toList(),
                ],
              ),
            ],
          ),
        ),
        _buildLibraryList(),
      ],
    );
  }

  Widget _buildLibraryList() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: _libraries.isEmpty
          ? const Center(
              child: Text('Yakında kütüphane bulunamadı'),
            )
          : ListView.builder(
              itemCount: _libraries.length,
              itemBuilder: (context, index) {
                final library = _libraries[index];
                // Türkçe karakterlerin doğru görüntülenmesi için
                final name = library['name'] as String;
                final address = library['address'] as String;

                return ListTile(
                  leading: Icon(
                    FontAwesomeIcons.bookOpen,
                    color: AppTheme.primaryColor,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  subtitle: Text(address),
                  onTap: () {
                    _mapController.move(library['position'], 16.0);
                    _showLibraryDetails(library);
                  },
                );
              },
            ),
    );
  }

  void _showLibraryDetails(Map<String, dynamic> library) {
    // Türkçe karakterlerin doğru görüntülenmesi için
    final name = library['name'] as String;
    final address = library['address'] as String;
    final operator = library['operator'] as String;
    final openingHours = library['opening_hours'] as String;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            if (address.isNotEmpty) ...[
              Text(
                'Adres:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryColor,
                ),
              ),
              Text(address),
              const SizedBox(height: 8),
            ],
            if (operator.isNotEmpty) ...[
              Text(
                'İşleten:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryColor,
                ),
              ),
              Text(operator),
              const SizedBox(height: 8),
            ],
            if (openingHours.isNotEmpty) ...[
              Text(
                'Çalışma Saatleri:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryColor,
                ),
              ),
              Text(openingHours),
              const SizedBox(height: 8),
            ],
            Text(
              'Konum:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryColor,
              ),
            ),
            Text(
              '${library['position'].latitude.toStringAsFixed(6)}, ${library['position'].longitude.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _mapController.move(library['position'], 16.0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  icon: const Icon(Icons.map),
                  label: const Text('Haritada Göster'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Burada yol tarifi için bir uygulama açılabilir
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                  ),
                  icon: const Icon(Icons.directions),
                  label: const Text('Yol Tarifi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
