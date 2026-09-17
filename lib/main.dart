import 'package:flutter/material.dart';

void main() {
  runApp(const ArtSpaceApp());
}

class ArtSpaceApp extends StatelessWidget {
  const ArtSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ArtSpaceScreen(),
    );
  }
}

// Simple model for one page
class Artwork {
  final String imageAsset;
  final String title;
  final String artist;
  final int year;

  const Artwork({
    required this.imageAsset,
    required this.title,
    required this.artist,
    required this.year,
  });
}

class ArtSpaceScreen extends StatefulWidget {
  const ArtSpaceScreen({super.key});

  @override
  State<ArtSpaceScreen> createState() => _ArtSpaceScreenState();
}

/// List of Artworks
class _ArtSpaceScreenState extends State<ArtSpaceScreen> {
  final List<Artwork> _artworks = const [
    Artwork(
      imageAsset: 'images/blue_roses.png',
      title: 'Still Life of Blue Rose and Other Flowers',
      artist: 'Owen Scott',
      year: 2021,
    ),
    Artwork(
      imageAsset: 'images/les_tres_riches_heures.png',
      title: 'Les Tres Riches Heures',
      artist: 'The Limbourg Brothers',
      year: 1412,
    ),
    Artwork(
      imageAsset: 'images/woman_in_blue.png',
      title: 'Woman in Blue Reading a Letter',
      artist: 'Johannes Vermeer',
      year: 1663,
    ),
  ];

  int _currentIndex = 0;

  void _goToPrevious() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _artworks.length) % _artworks.length;
    });
  }

  void _goToNext() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _artworks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Artwork current = _artworks[_currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Wall
                _ArtworkWall(imageAsset: current.imageAsset),
                const SizedBox(height: 32),

                /// Descriptor
                _ArtworkDescriptor(
                  title: current.title,
                  artist: current.artist,
                  year: current.year,
                ),
                const SizedBox(height: 24),

                /// Display Controller
                _DisplayController(
                  onPrevious: _goToPrevious,
                  onNext: _goToNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the artwork inside a white backdrop
class _ArtworkWall extends StatelessWidget {
  final String imageAsset;

  const _ArtworkWall({required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: Image.asset(
          imageAsset,
          height: 320,
          width: 260,
          fit: BoxFit.cover,
          // Fallback in case the asset hasn't been added yet.
          errorBuilder: (context, error, stackTrace) => Container(
            height: 320,
            width: 260,
            color: Colors.grey[300],
            alignment: Alignment.center,
            child: const Icon(Icons.image_not_supported, size: 48),
          ),
        ),
      ),
    );
  }
}

/// Shows the title, artist, and year underneath the artwork.
class _ArtworkDescriptor extends StatelessWidget {
  final String title;
  final String artist;
  final int year;

  const _ArtworkDescriptor({
    required this.title,
    required this.artist,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFECEBF4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                artist,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text('($year)'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Previous & Next buttons that navigates through the app.
class _DisplayController extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _DisplayController({
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: onPrevious,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Previous'),
          ),
        ),
        SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }
}