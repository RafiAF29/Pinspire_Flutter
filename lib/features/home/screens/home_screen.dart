import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/api_constants.dart';
import '../../pin/models/pin.dart';
import '../../pin/widgets/pin_card.dart';

/// Layar 1: feed 2 kolom — data diambil dari REST API /pins/feed.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pin> _pins = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchFeed();
  }

  Future<void> _fetchFeed() async {
    try {
      final res = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/pins/feed?per_page=20'),
        headers: ApiConstants.jsonHeaders,
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final List<dynamic> items = data['data'] ?? [];
        setState(() {
          _pins = items.map((json) => Pin.fromJson(json)).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Gagal memuat feed (${res.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Tidak bisa terhubung ke server.\nPastikan Laravel sudah jalan.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() { _loading = true; _error = null; });
                  _fetchFeed();
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    // Bagi pin ke 2 kolom (genap kiri, ganjil kanan).
    final left = <Pin>[];
    final right = <Pin>[];
    for (int i = 0; i < _pins.length; i++) {
      if (i.isEven) {
        left.add(_pins[i]);
      } else {
        right.add(_pins[i]);
      }
    }

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _fetchFeed,
        color: Colors.red,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _column(left)),
              const SizedBox(width: 6),
              Expanded(child: _column(right)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _column(List<Pin> pins) =>
      Column(children: [for (final p in pins) PinCard(pin: p)]);
}
